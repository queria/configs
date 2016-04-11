#!/bin/bash

export BUPD=$(mktemp -d --tmpdir "config-backup-XXXXXX")
export BUP_USED="${BUPD}/__bup_used"
export CHANGED="${BUPD}/__changed"
export MISSING_CMD="${BUPD}/__missing_cmd"

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
sudo_deplink() {
    SUDO="sudo -E" "$MYBIN/deplink" "$@"
}
cmd_check() {
    if ! eval $1 &> /dev/null; then
        touch "$MISSING_CMD"
        echo "Missing $2. $3";
    fi
}
bin_check() { cmd_check "which $1" "command $1" "$2"; }

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
    deplink .zsh_completion "$HOME/.zsh_completion"
    deplink .zsh_completion.d "$HOME/.zsh_completion.d"
    deplink .zshenv "$HOME/.zshenv"
    deplink .zlogout "$HOME/.zlogout"
    safemkdir "$HOME/.config/fish"
    deplink config.fish "$HOME/.config/fish/config.fish"

    safemkdir "$HOME/.config"
    safemkdir "$HOME/.local/share/applications"
    deplink mimeapps.list "$HOME/.config/mimeapps.list"
    deplink mimeapps.list "$HOME/.local/share/applications/mimeapps.list"
    deplink browser.desktop "$HOME/.local/share/applications/browser.desktop"

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

    safemkdir "$HOME/bin"
    deplink "/usr/bin/openstack" "$HOME/bin/os"

    sudo_deplink vok "/usr/share/X11/xkb/symbols/vok"
}
check_app_presence() {
	bin_check vim
	bin_check gvim
	bin_check htop
    bin_check ncdu
	bin_check screen
	bin_check strace
    bin_check zsh
    bin_check autojump
    bin_check fortune
    bin_check enca
    bin_check ctags
    bin_check elinks
    bin_check vncviewer
    bin_check osd_cat
    bin_check dolphin
    bin_check flake8 "python{,3}-flake8"
    bin_check openstack "python-openstackclient"
    cmd_check 'python -c "import jedi"' "python{,3}-jedi"
    cmd_check '[[ "$SHELL" =~ .*zsh ]]' "zsh as user shell"
}


safetycheck "$1"

cd "$(dirname $0)"
deploy_repos
deploy_configs

check_app_presence

fin_message
