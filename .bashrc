# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

[[ -e "$HOME/all" && ! -e "$HOME/all/tmp" ]] && (mkdir /tmp/ps_tmp; ln -snf /tmp/ps_tmp "$HOME/all/tmp")


# User specific aliases and functions
export EDITOR=/usr/bin/vim
export BC_ENV_ARGS="/home/psedlak/.bc"
#PATH="$HOME/all/src/go/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/all/src/scripts/:$PATH"
PATH="$HOME/bin:$PATH"
[[ -d "$HOME/all/src/os-kit/" ]] && PATH="$PATH:$HOME/all/src/os-kit"
export PATH
[[ -z "$MANPATH" ]] && export MANPATH="$HOME/all/docs/man:$(manpath)"

# for my custom built git
#PATH="/all/src/git:${PATH}"
#GIT_EXEC_PATH="/all/src/git"
#GITPERLLIB="/all/src/git/perl/blib/lib"
#export GIT_EXEC_PATH PATH GITPERLLIB



[ -f ~/.bash_aliases ] && . ~/.bash_aliases

shopt -s histappend
shopt -s lithist
export HISTTIMEFORMAT="%y-%m-%d - %H:%M:%S"
export HISTSIZE=100000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="bashno"

export PS1='\[\033[01;32m\]\u@\h\[\033[01;32m\] \W \$? \$\[\033[00m\] '
[[ -s "$HOME/.prompt_color" ]] && source "$HOME/.prompt_color"


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
        local stashed="$(git stash list 2>/dev/null| wc -l)"
        local clean="$(git status --porcelain 2>/dev/null| wc -l)"
        if [[ "$clean" = "0" ]]; then clean="01;30m<clean>"; else clean="00;35m<dirty>"; fi
        echo -e "$mark\033[00;07m$BR\033[00m \033[$clean+$stashed\033[00m"
    fi
}
export PS1="\[\033[01;30m=>\$?\[\033[00m  \$(parse-git-branch) \n$PS1"
 

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
export GOPATH=/all/src/go
