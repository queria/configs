#!/bin/bash

BUPD=$(mktemp -d --tmpdir "config-backup-XXXXXX")
BUP_USED=false
CHANGED=false

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
                echo "‘$tgt’ -> ‘$src’ [already]"
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

if [[ "$1" != "--force" && "$HOME" != "$(echo ~)" ]]; then
    echo "$$HOME[=$HOME] does not seem to match ~[=$(echo ~)] ... operation could be unsafe!"
    echo "You can use --force to override this check."
fi

cd "$(dirname $0)"
deplink .bash_profile "$HOME/.bash_profile"
deplink .bashrc "$HOME/.bashrc"
deplink .bc "$HOME/.bc"
deplink .gitattributes "$HOME/.gitattributes"
deplink .gitconfig "$HOME/.gitconfig"

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
