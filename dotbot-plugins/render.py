import os
import shutil
import dotbot
import dotbot.util
import jinja2
import yaml

from datetime import datetime


__all__ = ['JinjaRender']


def _exists(path):
    '''
    Returns true if the path exists.
    '''
    path = os.path.expanduser(path)
    return os.path.lexists(path)


def _is_regular_file(path):
    '''
    Returns true if the path is a regular file.
    '''
    path = os.path.expanduser(path)
    return os.path.isfile(path) and not os.path.islink(path)


class JinjaRender(dotbot.Plugin):
    '''
    A dotbot plugin that renders dotfiles from Jinja2 templates.
    '''

    _directive = 'render'
    _default_values = {
        'template': None,
        'create': False,
        'rerender': False,
        'backup': False,
        'force': False,
        'encoding': 'utf-8',
        'strict': False,
        'ignore-missing': False,
        'if': None,
        'context': {}
    }


    def can_handle(self, directive):
        '''
        Returns true if the plugin can handle the directive.
        '''
        return directive == self._directive


    def handle(self, directive, data):
        '''
        Executes the plugins directive.

        Returns true if the plugin successfully handled the directive.
        '''
        if directive != self._directive:
            raise ValueError('JinjaRender cannot handle directive {}'.format(directive))
        return self._process(data)


    def _process(self, data):
        '''
        Process the data associated with a render directive.

        This is expected to be a dict in the form of {destination: config, ...}.
        Each destination file is created by rendering the associated template.
        '''
        success = True
        for destination, config in data.items():
            destination = os.path.expandvars(destination)
            config = self._apply_defaults(destination, config)
            template = config.get('template')
            template = os.path.expandvars(os.path.expanduser(template))
            if not self._test_success(config.get('if')):
                self._log.lowinfo('Skipping {}'.format(destination))
                continue
            if not _exists(template) and not config.get('ignore_missing'):
                self._log.warning('Nonexistent template {} <- {}'.format(destination, template))
                success = False
                continue
            if _exists(destination):
                if _is_regular_file(destination) and not config.get('rerender'):
                    self._log.lowinfo('File {} exists'.format(destination))
                    continue
                if not _is_regular_file(destination) and not config.get('force'):
                    self._log.warning('{} exists but is not a regular file'.format(destination))
                    success = False
                    continue
                success &= self._remove_path(destination, backup=config.get('backup'))
            context = self._load_context(config.get('context'))
            if context is None:
                self._log.warning("Invalid context for {}".format(destination))
                success = False
                continue
            if config.get('create'):
                success &= self._create_path(destination)
            success &= self._render_template(template, destination, context,
                    encoding=config.get('encoding'),
                    strict=config.get('strict'),
                    ignore_missing=config.get('ignore_missing'))
        if success:
            self._log.info('All files have been rendered')
        else:
            self._log.error('Some files were not successfully rendered')
        return success


    def _apply_defaults(self, destination, config):
        '''
        Return the config for a destination with defaults filled in for any unsupplied settings.
        '''
        defaults = self._context.defaults().get(self._directive, {})
        fullcfg = { k: defaults.get(k, v) for k, v in self._default_values.items() }
        fullcfg.update({'template': self._default_template(destination)})
        if isinstance(config, dict):
            fullcfg.update(config)
        elif config is not None:
            fullcfg.update({'template': config})
        return fullcfg


    def _default_template(self, destination):
        '''
        Return the default template name for a destination.
        '''
        basename = os.path.basename(destination)
        if basename.startswith('.'):
            return basename[1:]
        else:
            return basename


    def _test_success(self, command):
        '''
        Return true if the shell command exits with return code 0.
        '''
        if command is not None:
            ret = dotbot.util.shell_command(command, cwd=self._context.base_directory())
            if ret != 0:
                self._log.debug('Test \'{}\' returned false'.format(command))
            return ret == 0
        else:
            return True


    def _create_path(self, path):
        '''
        Create the paths parent path.
        '''
        success = True
        parent = os.path.abspath(os.path.join(os.path.expanduser(path), os.pardir))
        if not _exists(parent):
            self._log.debug("Try to create parent: " + str(parent))
            try:
                os.makedirs(parent)
            except OSError as e:
                self._log.warning('Failed to create directory {}'.format(parent))
                self._log.debug("Exception: {}".format(e))
                success = False
            else:
                self._log.lowinfo('Creating directory {}'.format(parent))
        return success


    def _remove_path(self, path, backup=False):
        '''
        (Re)move the path, possibly backing it up with another name.
        '''
        success = True
        fullpath = os.path.expanduser(path)
        if not _exists(fullpath):
            return success
        if backup:
            timestamp = datetime.now().strftime('%Y%m%d%H%M%S')
            backup = "{}.{}".format(fullpath, timestamp)
            try:
                shutil.move(fullpath, backup)
            except (OSError, shutil.Error) as e:
                self._log.warning('Failed to move {}'.format(path))
                self._log.debug("Exception: {}".format(e))
                success = False
            else:
                self._log.lowinfo('Moving {} -> {}'.format(path, backup))
        else:
            try:
                if os.path.islink(fullpath):
                    os.unlink(fullpath)
                if os.path.isdir(fullpath):
                    shutil.rmtree(fullpath)
                else:
                    os.remove(fullpath)
            except (OSError, shutil.Error) as e:
                self._log.warning('Failed to remove {}'.format(path))
                self._log.debug("Exception: {}".format(e))
                success = False
            else:
                self._log.lowinfo('Removing {}'.format(path))
        return success


    def _load_context(self, data):
        '''
        Return a dict with the context for rendering a template.
        '''
        context = {'environ': dict(os.environ)}
        if isinstance(data, dict):
            context.update(data)
        elif data is not None:
            data = os.path.expandvars(os.path.expanduser(str(data)))
            try:
                with open(data, 'r') as f:
                    context.update(yaml.safe_load(f))
            except Exception as e:
                self._log.debug("Failed to load context from {}".format(data))
                self._log.debug("Exception: {}".format(e))
                return None
        return context


    def _render_template(self, source, destination, context={}, encoding='utf-8', strict=False, ignore_missing=False):
        '''
        Render the source template file to the destination file.
        '''
        success = False
        base_directory = self._context.base_directory()
        destpath = os.path.expanduser(destination)
        sourcepath = os.path.join(base_directory, os.path.expanduser(source))
        undefined = jinja2.StrictUndefined if strict else jinja2.Undefined
        loader = jinja2.FileSystemLoader(os.path.dirname(sourcepath), encoding=encoding, followlinks=True)
        env = jinja2.Environment(loader=loader, undefined=undefined)
        try:
            template = env.get_template(os.path.basename(sourcepath))
        except jinja2.TemplateNotFound as e:
            self._log.warning("Template {} not found".format(sourcepath))
            if ignore_missing:
                template = jinja2.Template("")
                sourcepath = "None"
                source = "None"
            else:
                self._log.debug("Exception: {}".format(e))
                return False
        except Exception as e:
            self._log.warning("Failed to load template {}".format(sourcepath))
            self._log.debug("Exception: {}".format(e))
            return False
        try:
            with open(destpath, 'wb') as f:
                for chunk in template.generate(context):
                    f.write(chunk.encode(encoding))
        except Exception as e:
            self._log.warning('Rendering {} failed'.format(destination))
            self._log.debug("Exception: {}".format(e))
            success = False
        else:
            self._log.lowinfo('Rendering file {} <- {}'.format(destination, sourcepath))
            success = True
        return success
