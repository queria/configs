#!/bin/bash

BUPD=$(mktemp -d --tmpdir "config-backup-XXXXXX")
BUP_USED=false
CHANGED=false

safetycheck() {
    if [[ "$1" != "--force" && "$HOME" != "$(echo ~)" ]]; then
        echo "$$HOME[=$HOME] does not seem to match ~[=$(echo ~)] ... operation could be unsafe!"
        echo "You can use --force to override this check."
        exit 1
    fi
}
bup() {
    BUP_USED=true
    mv -v "$1" "${BUPD}/${1//\//_}"
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
deploy_scripts() {
    if [[ ! -d "$HOME/all/src" ]]; then
        CHANGED=true
        mkdir -vp "$HOME/all/src"
    fi
    if [[ ! -d "$HOME/all/src/scripts" ]]; then
        CHANGED=true
        git clone git@github.com:queria/scripts.git "$HOME/all/src/scripts"
    fi
    if [[ -d "$HOME/.vim" ]]; then
        pushd "$HOME/.vim" > /dev/null
        git status &> /dev/null
        local rc="$?"
        popd > /dev/null
        if [[ "$rc" = "128" ]]; then
            bup "$HOME/.vim"
        fi
    fi
    if [[ ! -d "$HOME/.vim" ]]; then
        CHANGED=true
        git clone git@github.com:queria/my-vim.git "$HOME/.vim"
    fi
}
fin_message() {
    if ! $CHANGED; then
        echo ""
        echo "Seems all configs are already properly symlinked here."
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
}
deploy_configs() {
    deplink .bash_profile "$HOME/.bash_profile"
    deplink .bashrc "$HOME/.bashrc"
    deplink .bash_aliases "$HOME/.bash_aliases"
    deplink .bashnorc "$HOME/.bashnorc"
    deplink .bc "$HOME/.bc"
    deplink .gitattributes "$HOME/.gitattributes"
    deplink .gitconfig "$HOME/.gitconfig"
    deplink .Xdefaults "$HOME/.Xdefaults"
    [[ -s "$HOME/.i3" ]] || mkdir "$HOME/.i3"
    deplink i3-config "$HOME/.i3/config"
    deplink i3-status "$HOME/.i3status.conf"

    deplink "$HOME/.vim/qs_vimrc" "$HOME/.vimrc"
}


safetycheck "$1"

cd "$(dirname $0)"
deploy_scripts
deploy_configs

fin_message


