
Qu_add2path() {
    if ! expr match "$PATH" ".*${1}.*" &> /dev/null; then
        export PATH="${1}:${PATH}"
    fi
}
Qu_add2path "$HOME/.local/bin"
Qu_add2path "$HOME/all/src/scripts"
Qu_add2path "$HOME/bin"
[[ -d "$HOME/all/src/os-kit/" ]] && Qu_add2path "$HOME/all/src/os-kit"
[[ -d "$HOME/all/src/go/bin" ]] && Qu_add2path "$HOME/all/src/go/bin"
export PATH
[[ -z "$MANPATH" ]] && export MANPATH="$HOME/all/docs/man:$(manpath)"

export EDITOR=/usr/bin/vim
export TERMINAL=xterm
export BC_ENV_ARGS="$HOME/.bc"
export LESS="-FRX"

export LIBVIRT_DEFAULT_URI=qemu:///system
export GOPATH=$HOME/all/src/go
export QT_QPA_PLATFORMTHEME=qt5ct

[[ -f ~/.zshenv_local ]] && source ~/.zshenv_local
[[ -f ~/keystonerc ]] && source ~/keystonerc
