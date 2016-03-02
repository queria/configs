#!/bin/bash

export BUPD=$(mktemp -d --tmpdir "config-backup-XXXXXX")
export BUP_USED="${BUPD}/__bup_used"
export CHANGED="${BUPD}/__changed"

export EX_CLONE=11
export EX_MKDIR=12

export CLR_ERROR="\033[1;31m"
export CLR_ALREADY="\033[0;32m"
export CLR_NONE="\033[00m"

export MYBIN="$(dirname "$(readlink -f "$0")")/_bin"
export PATH="$MYBIN:${PATH}"

safetycheck() {
    if [[ "$1" != "--force" && "$HOME" != "$(echo ~)" ]]; then
        echo "$$HOME[=$HOME] does not seem to match ~[=$(echo ~)] ... operation could be unsafe!"
        echo "You can use --force to override this check."
        exit 1
    fi
    if [[ -z "$BUPD" ]]; then
        echo "Issue with getting temporary backup dir!"
        exit 1
    fi
}
safemkdir() {
    if ! mkdir -vp "$1"; then
        fin_message "mkdir $1"
        exit $EX_MKDIR
    fi
}
deprepo() {
    if ! "$MYBIN/deprepo" "$@"; then
        fin_message "Cloning $repo into $tgt"
        exit $EX_CLONE
    fi
}
deplink() {
    "$MYBIN/deplink" "$@"
}
sudo_deprepo() {
    if ! sudo -E "$MYBIN/deprepo" "$@"; then
        fin_message "Cloning $repo into $tgt"
        exit $EX_CLONE
    fi
}
sudo_deplink() {
    sudo -E "$MYBIN/deplink" "$@"
}

deploy_repos() {
    if [[ ! -d "$HOME/all/src" ]]; then
        touch "$CHANGED"
        mkdir -vp "$HOME/all/src"
    fi
    deprepo git@github.com:queria/scripts.git "$HOME/all/src/scripts"
    deprepo git@github.com:queria/my-vim.git "$HOME/.vim" "submodules"
    deprepo https://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh"
    deprepo git@github.com:tarruda/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    deprepo git@github.com:zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
}
deploy_configs() {
    deplink .bash_profile "$HOME/.bash_profile"
    deplink .bashrc "$HOME/.bashrc"
    deplink .bash_aliases "$HOME/.bash_aliases"
    deplink .bashnorc "$HOME/.bashnorc"
    deplink .bc "$HOME/.bc"
    deplink .zshrc "$HOME/.zshrc"
    deplink .zshenv "$HOME/.zshenv"
    deplink .zlogout "$HOME/.zlogout"
    safemkdir "$HOME/.config/fish"
    deplink config.fish "$HOME/.config/fish/config.fish"

    deplink .gitattributes "$HOME/.gitattributes"
    deplink .gitconfig "$HOME/.gitconfig"
    deplink .gitexcludes "$HOME/.gitexcludes"
    deplink .Xdefaults "$HOME/.Xdefaults"

    safemkdir "$HOME/.i3"
    deplink i3-config "$HOME/.i3/config"
    deplink i3-status "$HOME/.i3status.conf"
    safemkdir "$HOME/.config/dunst"
    deplink dunstrc "$HOME/.config/dunst/dunstrc"
    deplink addic7ed "$HOME/.config/addic7ed"
    safemkdir "$HOME/.config/openbox"
    deplink openbox.rc.xml "$HOME/.config/openbox/rc.xml"

    safemkdir "$HOME/.mplayer"
    deplink mplayer "$HOME/.mplayer/config"
    safemkdir "$HOME/.mpv"
    deplink mpv "$HOME/.mpv/config"

    deplink "$HOME/.vim/qs_vimrc" "$HOME/.vimrc"

    sudo_deplink vok "/usr/share/X11/xkb/symbols/vok"
}


safetycheck "$1"

cd "$(dirname $0)"
deploy_repos
deploy_configs

fin_message
