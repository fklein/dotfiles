# Exit if not running interactively
[[ $- != *i* ]] && return

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
HISTFILE="$HOME/.bash_history"
HISTCONTROL="ignoreboth"
HISTIGNORE="pwd:cd"
shopt -s histappend

# Set the prompt
PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '

# Make vim the standard editor
alias vi='vim'
export EDITOR='vim'

# Turn on colorful output in coreutils
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Basic convenience aliases
alias l='ls -CF'
alias ll='ls -lh'
alias la='ls -A'
alias lt='ls -ltrh'

# Prompt before overwriting
alias cp='cp -i'
alias mv='mv -i'

# Utility aliases
alias peek='tee >(cat 1>&2)'

# Utility functions
_appendpath() { [[ ":${PATH}:" != *":${1}:"* ]] && PATH="${PATH:+"${PATH}:"}${1}" ; }
_prependpath() { [[ ":${PATH}:" != *":${1}:"* ]] && PATH="${1}${PATH:+":${PATH}"}" ; }

# Load every "*.bash" file from ".bashrc.d"
for extfile in ~/.bashrc.d/*.bash; do
    [[ -f ${extfile} ]] && source "${extfile}"
done

# Apply machine specific settings
if [[ -f ~/.bashrc.local ]]; then
    source ~/.bashrc.local
fi
