
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

[[ -f ~/keystonerc_psedlak ]] && source ~/keystonerc_psedlak
