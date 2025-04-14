# Exit if not running interactively
[[ $- != *i* ]] && return

# Load global settings
if [[ -f /etc/bashrc ]]; then
    source /etc/bashrc
fi

# Enable default completion features
# Might already be present if enabled in /etc/bashrc or /etc/bash.bashrc
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
elif [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
fi

# Enable useful shell options
shopt -s cdspell
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s dirspell
shopt -s direxpand

# History settings
HISTSIZE=2500
HISTFILESIZE=10000
HISTFILE="${HOME}/.bash_history"
HISTCONTROL="ignoreboth"
HISTIGNORE="pwd:cd"
shopt -s histappend

# Set the prompt
# Hint: Escape non-printable sequences, or line wrapping will not work correctly!
PS1='\[\e[1;39m\][\[\e[1;32m\]\u@\h \[\e[1;34m\]\w\[\e[1;39m\]]$ \[\e[0m\]'

# Display the current directory in the terminal title.
# For remote sessions also include user and hostname.
if [[ -n ${SSH_CLIENT} ]] || [[ -n ${SSH_TTY} ]]; then
    PROMPT_COMMAND='printf "\e]0;%s@%s:%s\a" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
else
    PROMPT_COMMAND='printf "\e]0;%s\a" "${PWD/#$HOME/\~}"'
fi

# Make neovim the standard editor (fallback to vim or vi)
export EDITOR="vi"
export VISUAL="vi"
if command -v nvim &>/dev/null; then
    alias vi='nvim'
    alias vim='nvim'
    export EDITOR="nvim"
    export VISUAL="nvim"
elif command -v vim &>/dev/null; then
    alias vi='vim'
    export EDITOR="vim"
    export VISUAL="vim"
fi

# Turn on colorful output in coreutils
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Load custom color settings
if [[ -f ~/.dircolors ]] && command -v dircolors &>/dev/null; then
    eval "$(dircolors -b ~/.dircolors)"
fi

# Basic convenience aliases
alias l='ls -CF'
alias la='ls -ACF'
alias lh='ls -ACF --ignore=[^.]\*'
alias ll='ls -lh'
alias lt='ls -lhtr'
alias lb='ls -lhSr'

# Prompt before overwriting
alias cp='cp -i'
alias mv='mv -i'

# Default to human readable file size format
alias df='df -h'
alias du='du -h'

# Utility functions
_appendpath() { [[ ":${PATH}:" != *":${1}:"* ]] && PATH="${PATH:+"${PATH}:"}${1}" ; }
_prependpath() { [[ ":${PATH}:" != *":${1}:"* ]] && PATH="${1}${PATH:+":${PATH}"}" ; }
_removepath() { PATH="${PATH//":${1}:"/":"}" ; PATH="${PATH/#"${1}:"/""}" ; PATH="${PATH/%":${1}"/""}" ; }

# Load every "*.bash" file from ".bashrc.d"
for extfile in ~/.bashrc.d/*.bash; do
    [[ -f ${extfile} ]] && source "${extfile}"
done
unset extfile

# Apply machine specific settings
if [[ -f ~/.bashrc.local ]]; then
    source ~/.bashrc.local
fi
