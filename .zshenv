
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/all/src/scripts:$PATH"
PATH="$HOME/bin:$PATH"
[[ -d "$HOME/all/src/os-kit/" ]] && PATH="$PATH:$HOME/all/src/os-kit"
export PATH
[[ -z "$MANPATH" ]] && export MANPATH="$HOME/all/docs/man:$(manpath)"

export EDITOR=/usr/bin/vim
export BC_ENV_ARGS="$HOME/.bc"

export LIBVIRT_DEFAULT_URI=qemu:///system
export GOPATH=$HOME/all/src/go

[[ -f ~/keystonerc_psedlak ]] && source ~/keystonerc_psedlak
