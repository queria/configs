#!/usr/bin/bash

sudo dnf install \
    gcc golang redhat-rpm-config \
    python-devel python-pip \
    strace gdb \
    htop iftop iptraf-ng \
    zsh autojump-zsh \
    network-manager-applet xosd xbacklight kbd qt5-qttools \
    i3 feh fluxbox i3lock rxvt-unicode clipit dunst gwenview \
    git vim-enhanced


if [[ ! -f $HOME/.local/bin/pip ]]; then
    pip install -U --user pip
    pip install -U --user python-openstackclient virtualenv ipython
fi

if [[ ! -f /usr/local/bin/dmenu_hist ]]; then
    export GOPATH=$HOME/all/src/go
    mkdir -p $GOPATH
    go get github.com/queria/dmenu_hist
    sudo cp $GOPATH/bin/dmenu_hist /usr/local/bin/
fi


[[ "$SHELL" = "/bin/zsh" ]] || chsh -s /bin/zsh
