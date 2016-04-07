# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

cd $HOME

if [[ ! -d /tmp/ps_tmp ]]; then
    mkdir /tmp/ps_tmp;
fi
if [[ -e "$HOME/all" && ! -e "$HOME/all/tmp" ]]; then
    ln -snf /tmp/ps_tmp/ "$HOME/all/tmp"
fi

# User specific aliases and functions
export EDITOR=/usr/bin/vim
export TERMINAL=xterm
export BC_ENV_ARGS="$HOME/.bc"

#PATH="$HOME/all/src/go/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/all/src/scripts/:$PATH"
PATH="$HOME/bin:$PATH"
if [[ -d "$HOME/all/src/os-kit/" ]]; then
    PATH="$PATH:$HOME/all/src/os-kit";
fi
export PATH

if [[ -z "$MANPATH" ]]; then
    export MANPATH="$HOME/all/docs/man:$(manpath)"
fi

# for my custom built git
#PATH="$HOME/all/src/git:${PATH}"
#GIT_EXEC_PATH="$HOME/all/src/git"
#GITPERLLIB="$HOME/all/src/git/perl/blib/lib"
#export GIT_EXEC_PATH PATH GITPERLLIB


[ -f ~/.bash_aliases ] && . ~/.bash_aliases


parse-git-branch() {
    local BR=$(git branch --no-color 2>/dev/null | sed -n "s/^\* \(.*\)\$/\1/p")
    #local mark='⊪'
    #mark='⋲'
    #mark=' ⤊ ⤋ ⤌ ⤍ ⤎ ⤏ ⤐ ⤑ ⤒ ⤓ ⤔ ⤕ ⤖ ⤗ ⤘ ⤙ ⤚ ⤛ ⤜ ⤝ ⤞ ⤟ ⤠'
    #mark='《 》 「 」 『 』 【 】 〒 〓 〔 〕 〖 〗 〘 〙 〚 〛'
    #mark='︽ ︾'
    #mark='⋘ ⋙'
    if [[ ! -z "$BR" ]]; then
        local mark='〒'
        local markE=''
        local stashed="$(git stash list 2>/dev/null| wc -l)"
        local clean="$(git status --porcelain 2>/dev/null| wc -l)"
        if [[ "$clean" = "0" ]]; then clean="01;30m<clean>"; else clean="00;35m<dirty>"; fi
        echo -e "$mark\033[00;07m$BR\033[00m$markE \033[$clean+$stashed\033[00m"
    fi
}
export PS1='\033[01;32m\u@\h\033[01;32m \w \033[00m '
[[ -s "$HOME/.prompt_color" ]] && source "$HOME/.prompt_color"
#export PS1="\[\033[01;30m=>\$?\[\033[00m  \$(parse-git-branch) \n$PS1"
export PS1="\033[01;30m=>\$?\033[00m $PS1\$(parse-git-branch)\n\033[01;32m$\033[00m "


shopt -s histappend
shopt -s lithist
export HISTTIMEFORMAT="%y-%m-%d - %H:%M:%S"
export HISTSIZE=100000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="bashno"
shopt -s checkhash
shopt -s no_empty_cmd_completion

set -o vi
set completion-query-items 200
bind "\C-l":clear-screen

uservm() {
    if ! type rvm 2>&1 |grep function &>/dev/null; then
        [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm";
        [[ -s "$HOME/.rvm/scripts/completion" ]] && . "$HOME/.rvm/scripts/completion";
    fi;
}

[[ -f ~/all/src/machine-tools/lib/rhosqe_env ]] && . ~/all/src/machine-tools/lib/rhosqe_env

export LIBVIRT_DEFAULT_URI=qemu:///system
export GOPATH=$HOME/all/src/go

if [[ -f ~/keystonerc_psedlak ]]; then
    source ~/keystonerc_psedlak;
fi
