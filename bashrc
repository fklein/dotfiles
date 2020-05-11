# Exit if not running interactively
[[ $- != *i* ]] && return

#
shopt -s histappend
shopt -s cdspell
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s dirspell
shopt -s direxpand

alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -lA'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'

# Load machine specific settings
if [[ -f ~/.bashrc.local ]]; then
    source ~/.bashrc.local
fi
