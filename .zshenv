
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/all/src/scripts:$PATH"
PATH="$HOME/bin:$PATH"
[[ -d "$HOME/all/src/os-kit/" ]] && PATH="$PATH:$HOME/all/src/os-kit"
[[ -d "$HOME/all/src/go/bin" ]] && PATH="$HOME/all/src/go/bin:$PATH"
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
