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
sudo_copy() {
    local src="$(readlink -f "$1")"
    local tgt="$2"
    local own="$3"
    local perms="$4"

    if [[ -d "$tgt" ]]; then
        # when dest is dir, append file name for diffing
        tgt="$(readlink -f "$tgt")/$(basename "$src")"
    fi

    if [[ -e "$tgt" && ! -f "$tgt" ]]; then
        fin_message "Unable to copy ${src} as ${tgt} (not a file...), please inspect and fix."
        return
    fi

    if diff "$src" "$tgt" &> /dev/null; then
        echo -e "${CLR_ALREADY}‘$tgt’ == ‘$src’ [already]${CLR_NONE}";
    else
        touch "$CHANGED"
        if [[ -e "$tgt" ]]; then
            SUDO="sudo -E" bup "$tgt" || fin_message "Unable to backup '$tgt'."
        fi
        sudo -E cp -v "$src" "$tgt" || fin_message "Unable to copy '$src' to '$tgt'."
        if [[ ! -z "$own" ]]; then
            sudo -E chown "$own" "$tgt" || fin_message "Unable to change ownership on '$tgt'."
        fi
        if [[ ! -z "$perms" ]]; then
            sudo -E chmod "$perms" "$tgt" || fin_message "Unable to change permissions on '$tgt'."
        fi
    fi
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
    deprepo git@github.com:agiz/youtube-mpv.git "$HOME/all/src/youtube-mpv"
}
deploy_configs() {
    deplink .bash_profile "$HOME/.bash_profile"
    deplink .bashrc "$HOME/.bashrc"
    deplink .bash_aliases "$HOME/.bash_aliases"
    deplink .bashnorc "$HOME/.bashnorc"
    deplink .bc "$HOME/.bc"
    deplink .zshrc "$HOME/.zshrc"
    deplink .zsh_completion "$HOME/.zsh_completion"
    deplink .zsh_bashcomp.d/ "$HOME/.zsh_bashcomp.d"
    deplink .zshenv "$HOME/.zshenv"
    deplink .zlogout "$HOME/.zlogout"
    safemkdir "$HOME/.config/fish"
    deplink config.fish "$HOME/.config/fish/config.fish"

    safemkdir "$HOME/.config"
    safemkdir "$HOME/.local/share/applications"
    deplink mimeapps.list "$HOME/.config/mimeapps.list"
    deplink mimeapps.list "$HOME/.local/share/mimeapps.list"
    deplink mimeapps.list "$HOME/.local/share/applications/mimeapps.list"
    deplink browser.desktop "$HOME/.local/share/applications/browser.desktop"

    deplink .gitattributes "$HOME/.gitattributes"
    deplink .gitconfig "$HOME/.gitconfig"
    deplink .gitexcludes "$HOME/.gitexcludes"
    deplink .Xdefaults "$HOME/.Xdefaults"

    safemkdir "$HOME/.i3"
    gen i3-config.sh "$HOME/.i3/config"
    deplink i3-status "$HOME/.i3status.conf"
    safemkdir "$HOME/.config/dunst"
    deplink dunstrc "$HOME/.config/dunst/dunstrc"
    deplink addic7ed "$HOME/.config/addic7ed"
    safemkdir "$HOME/.config/openbox"
    deplink openbox.rc.xml "$HOME/.config/openbox/rc.xml"
    deplink openbox.rc.xml "$HOME/.config/openbox/lxqt-rc.xml"

    safemkdir "$HOME/.config/clipit"
    deplink clipitrc "$HOME/.config/clipit/clipitrc"
    safemkdir "$HOME/.local/share/clipit"
    deplink clipit_excludes "$HOME/.local/share/clipit/excludes"

    safemkdir "$HOME/.mplayer"
    deplink mplayer "$HOME/.mplayer/config"
    safemkdir "$HOME/.mpv"
    deplink mpv "$HOME/.mpv/config"

    deplink "$HOME/.vim/qs_vimrc" "$HOME/.vimrc"

    safemkdir "$HOME/bin"
    deplink "/usr/bin/openstack" "$HOME/bin/os"

    sudo_deplink vok "/usr/share/X11/xkb/symbols/vok"
    sudo_copy unfuck-systemd-pager.sh /etc/profile.d/ root:root 644
    sudo_copy unfuck-systemd-pager.csh /etc/profile.d/ root:root 644
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
    bin_check pip
    bin_check virtualenv
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

if [[ ! -f "${MISSING_CMD}" ]]; then
    if ! ./youtube-mpv-install.sh "$HOME/all/src/youtube-mpv"; then
        fin_message "youtube-mpv setup, please debug it:\n  ./youtube-mpv-install.sh '$HOME/all/src/youtube-mpv'"
    fi
fi

fin_message
