# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
export EDITOR=/usr/bin/vim
export BC_ENV_ARGS=$(readlink -f "~/.bc")
export PATH="~/all/src/scripts/:~/bin:$PATH:$HOME/.local/bin"

[ -f ~/.bash_aliases ] && . ~/.bash_aliases

shopt -s histappend
shopt -s lithist
export HISTTIMEFORMAT="%y-%m-%d - %H:%M:%S"
export HISTSIZE=10000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="bashno"

export PS1='\[\033[01;32m\]\u@\h\[\033[01;32m\] \W \$\[\033[00m\] '
[[ -s "$HOME/.prompt_color" ]] && source "$HOME/.prompt_color"
 

shopt -s checkhash
shopt -s no_empty_cmd_completion

set -o vi
set completion-query-items 200
bind "\C-l":clear-screen

