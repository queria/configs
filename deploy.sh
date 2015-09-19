#!/bin/bash

BUPD=$(mktemp -d --tmpdir "config-backup-XXXXXX")
BUP_USED=false
CHANGED=false

EX_CLONE=11
EX_MKDIR=12

safetycheck() {
    if [[ "$1" != "--force" && "$HOME" != "$(echo ~)" ]]; then
        echo "$$HOME[=$HOME] does not seem to match ~[=$(echo ~)] ... operation could be unsafe!"
        echo "You can use --force to override this check."
        exit 1
    fi
}
fin_message() {
    if [[ ! -z "$1" ]]; then
        echo -e "\033[1;31m** FAILED: $1 **\033[00m"
    elif ! $CHANGED; then
        echo ""
        echo -e "\033[0;36mSeems all configs are already deployed here.\033[00m"
        echo ""
    fi
    if $BUP_USED; then
        echo ""
        echo "All original files were moved to"
        echo "$BUPD"
        echo "You can inspect it, opt. merge with deployed configs,"
        echo "and delete the directory"
    else
        rmdir "$BUPD"
    fi
    if [[ ! -z "$2" ]]; then
        exit $2
    fi
}
bup() {
    BUP_USED=true
    mv -v "$1" "${BUPD}/${1//\//_}"
}
bup_if_not_repo() {
    if [[ -d "$1" ]]; then
        pushd "$1" > /dev/null
        git status &> /dev/null
        local rc="$?"
        popd > /dev/null
        if [[ "$rc" = "128" ]]; then
            bup "$1"
        fi
    fi
}
deplink() {
    local src="$(readlink -f $1)"
    local tgt="$2"
    if [[ -f "$tgt" ]]; then
        if [[ -L "$tgt" ]]; then
            src_tgt="$(readlink -f "$tgt")"
            if [[ "$src" = "$src_tgt" ]]; then
                echo -e "\033[1;30m‘$tgt’ -> ‘$src’ [already]\033[00m";
                # link already matches
                return
            fi
        fi
        bup "$tgt"
    fi
    CHANGED=true
    if [[ ! -e "$tgt" ]]; then
        ln -vsnf "$src" "$tgt"
    else
        echo "Unable to deploy ${src} as ${tgt} (not a file...), please inspect and fix."
    fi
}
deprepo() {
    local repo=$1
    local tgt=$2
    local deep=false
    if [[ "$3" = "submodules" ]]; then
        deep=true
    fi

    bup_if_not_repo "$tgt"

    if [[ ! -d "$tgt" ]]; then
        CHANGED=true
        echo "‘$tgt’ -> ‘$repo’ [cloning]";
        git clone --depth=1 "$repo" "$tgt" || fin_message "Cloning $repo into $tgt" $EX_CLONE
        if $deep; then
            pushd "$tgt" > /dev/null
            (git submodule init && git submodule update --remote) || fin_message "Submodule init/update in $tgt"
            popd > /dev/null
        fi
    else
        echo -e "\033[1;30m‘$tgt’ -> ‘$repo’ [already]\033[00m";
    fi
}
deploy_repos() {
    if [[ ! -d "$HOME/all/src" ]]; then
        CHANGED=true
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
    mkdir -vp "$HOME/.config/fish" || fin_message "mkdir .config/fish" $EX_MKDIR
    deplink config.fish "$HOME/.config/fish/config.fish"

    deplink .gitattributes "$HOME/.gitattributes"
    deplink .gitconfig "$HOME/.gitconfig"
    deplink .Xdefaults "$HOME/.Xdefaults"

    mkdir -vp "$HOME/.i3" || fin_message "mkdir .i3" $EX_MKDIR
    deplink i3-config "$HOME/.i3/config"
    deplink i3-status "$HOME/.i3status.conf"
    mkdir -vp "$HOME/.config/dunst" || fin_message "mkdir .config/dunst" $EX_MKDIR
    deplink dunstrc "$HOME/.config/dunst/dunstrc"
    deplink addic7ed "$HOME/.config/addic7ed"

    deplink "$HOME/.vim/qs_vimrc" "$HOME/.vimrc"
}


safetycheck "$1"

cd "$(dirname $0)"
deploy_repos
deploy_configs

fin_message


