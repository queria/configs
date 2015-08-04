
set -x EDITOR /usr/bin/vim
set -x BC_ENV_ARGS "$HOME/.bc"
##PATH="$HOME/all/src/go/bin:$PATH"
set -x PATH /usr/sbin $PATH
set -x PATH $HOME/.local/bin $PATH
set -x PATH $HOME/all/src/scripts/ $PATH
set -x PATH $HOME/bin $PATH
[ -d "$HOME/all/src/os-kit/" ]; and set -x PATH $PATH $HOME/all/src/os-kit
[ -z "$MANPATH" ]; and set -x MANPATH $HOME/all/docs/man (manpath)

set -x LIBVIRT_DEFAULT_URI qemu:///system
set -x GOPATH $HOME/all/src/go

#    export PS1='\[\033[01;32m\]\u@\h\[\033[01;32m\] \W \$? \$\[\033[00m\] '
#    [[ -s "$HOME/.prompt_color" ]] && source "$HOME/.prompt_color"
#end

function parse-git-branch
    set BR (git branch --no-color 2>/dev/null | sed -n "s/^\* \(.*\)\$/\1/p")
    #local mark='⊪'
    #mark='⋲'
    #mark=' ⤊ ⤋ ⤌ ⤍ ⤎ ⤏ ⤐ ⤑ ⤒ ⤓ ⤔ ⤕ ⤖ ⤗ ⤘ ⤙ ⤚ ⤛ ⤜ ⤝ ⤞ ⤟ ⤠'
    #mark='《 》 「 」 『 』 【 】 〒 〓 〔 〕 〖 〗 〘 〙 〚 〛'
    #mark='︽ ︾'
    #mark='⋘ ⋙'
    if [ ! -z "$BR" ]
        #set mark '〒'

        set stashed (git stash list 2>/dev/null | wc -l)
        set clean (git status --porcelain 2>/dev/null | wc -l)

        echo -n "@$BR "
        if [ "$clean" = "0" ]
            set_color -o 666
            echo -n "<clean>"
        else
            set_color 808
            echo -n "<dirty>"
        end
        echo -n "+$stashed "
        set_color normal
    end
end

function fish_prompt
    set_color green
    echo -n "$USER@"(hostname)" "

    set_color 88F
    echo -n (date "+%H:%M:%S")" "

    set_color 880
    echo -n (prompt_pwd)' '

    set_color 888
    parse-git-branch
    set_color normal

    set_color FF0
    echo ''
    echo -n '$ '

    set_color normal
end

function fish_greeting
end

#export PS1="\[\033[01;30m=>\$?\[\033[00m  \$(parse-git-branch) \n$PS1"
function ll
    ls -lha --group-directories-first $argv
end
function lg
    # FIXME: argv testing and expansion
    if [ (count $argv) -gt 1 ]
        ll $argv[2] | grep -i $argv[1]
    else
        ll | grep -i $argv[1]
    end
end

function psg
    ps -ef | grep -v 'grep' | grep -i $argv
end
function vw
    set FILES (which $argv)
    if [ ! -z "$FILES" ]
        vim -p "$FILES"
    end
end

function mp; mpv $argv; end
function mps; addic7ed $argv[1]; mp $argv; end
function youtube-dl; youtube-dl --title --no-mtime $argv; end

function bashno
    bash --rcfile ~/.bashnorc
    [ ! -f ~/.bash_nohistory ]; and rm ~/.bash_nohistory
end
