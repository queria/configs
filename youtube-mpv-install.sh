#!/bin/bash
# modified version of install-fedora.sh from youtube-mpv repo

set -e

YMPV_DIR="$(readlink -f "$1")"
VENV="${XDG_DATA_HOME:-$YMPV_DIR}/.youtube-mpv-venv"
CFGDIR="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"

if [[ -e "$VENV/bin/activate" ]]; then
    echo -e "${CLR_ALREADY}youtube-mpv: venv [already]${CLR_NONE}";
else
    echo "youtube-mpv: venv";
    virtualenv "$VENV"
    source "$VENV/bin/activate"
    python -m youtube_dl --help &> /dev/null || pip install youtube_dl
    deactivate
fi


if systemctl --user --quiet is-active youtube-mpv; then
    echo -e "${CLR_ALREADY}youtube-mpv: systemd service [already]${CLR_NONE}";
else
    echo "youtube-mpv: systemd service";
    [[ -d "$CFGDIR" ]] || mkdir -p "$CFGDIR"

    cat > "$CFGDIR/youtube-mpv.service" <<EOF
[Unit]
Description=Python server which can play youtube links

[Service]
Type=simple
ExecStart=${VENV}/bin/python "${YMPV_DIR}/ytdl_server.py"

[Install]
WantedBy=default.target
EOF

    systemctl --user daemon-reload
    systemctl --user restart youtube-mpv
    systemctl --user enable youtube-mpv
fi
