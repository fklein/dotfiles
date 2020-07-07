" Use Vim settings, rather then Vi settings.
" This must be first, because it changes other options as a side effect.
set nocompatible

"
" Basic editor settings
"
set shortmess+=I                " Disable startup message
set history=8192                " More history
set number                      " Show line numbers
set numberwidth=5               " Set width of line numbers
set nowrap                      " Don't wrap text
set modeline                    " Allow modelines
set ruler                       " Always show info along bottom.
set laststatus=2                " Last window always has a statusline
set backspace=indent,eol,start  " Allow backspacing over everything

" What to display in list mode
set listchars=trail:_,nbsp:~,precedes:<,extends:>,tab:..,space:·

"
" Syntax highlighting
"
syntax enable                   " Enable syntax highlighting (previously syntax on).
set showmatch                   " Show matching braces when text indicator is over them

"
" Indentation settings
"
set tabstop=4                   " Number of spaces displayed for a <Tab>
set softtabstop=4               " Number of spaces (or <Tab>) to insert
set expandtab                   " Use spaces instead of tabs
set smarttab                    " Use tabs at the start of a line, spaces elsewhere
set shiftwidth=4                " Shift/Unshift by 4 spaces
set shiftround                  " Only use multiples of <shiftwidth>

"
" Search settings
"
set hlsearch                    " Highlight searched phrases
set incsearch                   " Highlight as you type your search
set ignorecase                  " Make searches case-insensitive
set smartcase                   " Case matthers only with mixed case expressions

" Center screen on search result
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

"
" Handling of backup files
"
set backup
set writebackup
set swapfile
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

"
" Attempt to apply the default colorscheme
"
silent! colorscheme default

"
" Apply the solarized colorscheme
"
set background=dark
let g:solarized_termcolors=256
colorscheme solarized

"
" Enable mouse mode (scrolling, selection, etc)
"
set mouse+=a
set ttymouse=xterm2

"
" Tab completion options
"
set completeopt=longest,menu            " Only complete to the longest unambiguous match, and show a menu
set wildmode=list:longest,list:full
set complete=.,t

"
" Enable filetype detection if available
"
if has("autocmd")
    " Enable file type detection
    filetype on
    " Use language-dependent indenting.
    filetype plugin on
    filetype indent on

    " Disable smart indenting
    set nosmartindent

    " Set File type to 'text' for files ending in .txt
    autocmd BufNewFile,BufRead *.txt setfiletype text

    " Enable soft-wrapping for text files
    autocmd FileType text,markdown setlocal wrap linebreak nolist
else
    " If filetype detection is unavailable use auto and smart indenting
    set autoindent
    set smartindent
endif

"
" Code folding settings
"
if has("folding")
    set nofoldenable
    set foldmethod=syntax
    set foldlevel=1
    set foldnestmax=10
endif

"
" Define custom shortcuts
"
let mapleader = ","

" Toggle search highlighting
nmap <Leader>h :set invhls <CR>

" Toggle list mode
nmap <Leader>l :set invlist <CR>

" Insert the current files path in command mode
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" Replace all tabs with 4 spaces each
nnoremap <leader><Space> :%s/<Tab>/    /g <CR>

" Remove trailing spaces
nnoremap <leader>t :%s/[[:space:]][[:space:]]*$//g <CR>

" nnoremap <leader>v :tabedit ~/.vimrc<CR>
" nnoremap <S-s> :w<CR>     " Quick Save

"
" Define custom commands
"
command! Gi :e .gitignore

"
" Load a local config if it exists
"
let $LOCALFILE=expand("~/.vimrc.local")
if filereadable($LOCALFILE)
  source $LOCALFILE
endif
