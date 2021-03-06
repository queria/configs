# vim: syn=sh:et:ts=4:sw=4

export GREP_COLOR=31

[[ "$SHELL" != "/usr/bin/zsh" ]] && unalias -a

alias grep='grep --color=auto'
alias less='less -r'
alias more='less'
alias vim='vimx'
alias v='vim'
alias vv='view'

export PAGER='less'
#export PAGER='view'
alias | grep -q '^\(alias \)\?ls=' && unalias ls
alias | grep -q '^\(alias \)\?ll=' && unalias ll
alias ls="ls --color=auto"
alias cal='cal -m'

topp () { top -n 1; }
ll () { ls -lha --group-directories-first "$@" ; }
lls () { ll "$@" | less; }
lg () { ( ( [ -z "$2" ] && ll ) || ll "$2" ) | grep -i "$1"; }
lt () { ll -tr "$@"; }
lll () { ll -tr "$@"|tail; }
llS () { ll -Sr "$@"|tail; }
dff () { df -x devtmpfs -x iso9660 -x tmpfs -h --output=target,pcent,ipcent,size,used,avail,fstype,source; }
psg () { ps -ef | grep -v 'grep' | grep -i "$@"; }
pswine () { ps -ef|grep -E '[.]exe|[w]ine'; }
scrr () { screen -d -R $@; }
tmx () { tmux has &>/dev/null && tmux attach -d -t 0 || tmux ; }
cdl () { cd "$1" && ll; }
cds () { cd /all/src/$1; }
cdt () { cd /all/tmp; }
cdtl () { cd /all/tmp; lll "$@"; }
pgrill () { psg "$@"; pkill "$@"; }

vw () { FILES=$(which "$@"); if [ "x$FILES" != "x" ]; then vim -p "$FILES"; fi; }
vf () { FILES=$(find -iname "*$@*"); if [ "x$FILES" != "x" ]; then vim -p "$FILES"; fi; }
cw () { FILES=$(which "$@"); [[ ! -z "$FILES" ]] && cat $FILES; }

qcal () {
    cal $(date -d "month ago" "+%m %Y");
    cal;
    cal $(date -d "next month" "+%m %Y");
}

svc () {
  local SUDO=""
  [[ "$UID" == "0" ]] || SUDO="sudo";
  $SUDO systemctl $1 $2.service;
}
start () { svc start $1; }
stop() { svc stop $1; }
restart () { svc restart $1; }

va () { source $1/bin/activate; }
vd () { deactivate; }

alias mpc-usb="mpc enable 2 && mpc disable 1"
alias mpc-ntb="mpc enable 1 && mpc disable 2"

alias mplayer=mpv
mp () { mplayer "$@"; }
mpm () {
    ARGS=("$@");
    if [[ "${#ARGS[@]}" = "0" ]]; then
        local AUTOPICKED="$(find /all/music/ -maxdepth 1 -type d|grep -v '^/all/music/$'|grep -v 'FLAC' | sort -R|head -n1)";
        echo "Auto-picked $AUTOPICKED"
        ARGS=("${ARGS[@]}" "$AUTOPICKED");
    fi;
    mpv -vo=null --shuffle "${ARGS[@]}";
}
mps () { addic7ed "$1"; mp "$@"; }
mpp () { mplayer -demuxer lavf "$@"; }
mpns () { mplayer -af volume=-200 "$@"; }
mplast_helper () {
    ls -1 -tr | grep -E "avi|mp4|wmv|mkv" | tail -n1;
}
mplast () {
    local lastf="$(mplast_helper)"
    typeset -a opts
    if which mpv &> /dev/null; then
        opts=("--index=recreate")
    else
        opts=("-idx")
    fi
    local lastffinal="${lastf%.crdownload}"
    lastffinal="${lastffinal%.part}"
    local subs=""
    if [[ "x$1" == "x-s" ]]; then
        shift
        local base="${lastffinal%.*}"  # strip suffix

        subs="${base}.srt"

        # workaround for ".US." being stuffed in regular file names (Forever.sris)
        subsfor="$(sed "s/\.US\./\./" <<< "$lastf")"
        subs="$(sed "s/\.US\./\./" <<< "$subs")"
        # otherwise the subsfor == lastf

        [[ -e "${subs}" ]] || addic7ed "$subsfor"
        [[ -e "${subs}" ]] && opts=("${opts[@]}" "-sub-file" "${subs}")
    fi

    set -x;
    mplayer "${opts[@]}" "$@" "$lastf";
    set +x;
    echo "Last was: ${lastf}";
    echo "playable like:";
    echo "";
    if [[ -z "${subs}" ]]; then
        echo "mplayer \"${lastffinal}\"";
    else
        echo "mplayer -sub-file \"${subs}\" \"${lastffinal}\"";
    fi
    echo "";
}
mplasts () {
    mplast -s "$@"
}
find_vid() {
    F="find ${1:-$(pwd)} -regextype posix-extended -iregex"
    $F '.*\.(avi|flv|mp4|mpg|wmv)'
    $F '.*\.(part|rar)' >&2
}
mprand () {
    mp --no-resume-playback --playlist=<(find_vid 2>/dev/null | sort --random-sort) ;
}

alias youtube-dl="youtube-dl --title --no-mtime"
alias jjb='jenkins-jobs'

#alias mc="LC_ALL=C mc"
alias mc="PAGER=view mc"
alias man="LANG=C man"

bashno ()
{
    bash --rcfile ~/.bashnorc;
    [[ ! -f ~/.bash_nohistory ]] || rm ~/.bash_nohistory;
}

pubscreen () {
    if [ -z "$1" ];
    then
        echo "Please specify screenshot name"
        return
    fi
    local OPWD=$(pwd);
    cd /tmp;
    scrot "$1".png && pub "$1".png && rm "$1".png;
    cd $OPWD;
}

tarjd () {
    if [ ! -d "$1" ]; then
        echo "expected one argument - directory"; return 1;
    fi;
    while [ ! -z "$1" ];
    do
        if [ ! -d "$1" ];
        then
            echo "$1 is not a directory!";
        else
            local SRC="${1}"
            local TGT="$(basename "${1}").tar.bz2"
            echo -n "tarring ${TGT} ... "
            tar cjf "${TGT}" "${SRC}";
            echo "done"
        fi
        shift
    done;
}

validateHtml5 () {
    if [ "x$1" == "x" ]; then
        echo "need url of html5 file"; return 1;
    fi;
    wget -q -O - "$1" | html5check.py -h;
}
rstview () {
    rst2html "$@" |elinks -force-html;
}

con () {
    if [[ -z "$1" ]]; then
        nmcli c show --active;
        iwlist wlan0 scan|grep -i ssid;
    else
        if nmcli c show --active | grep -q "^$1 "; then
            nmcli c down id "$1";
            sleep 0.5;
        fi
        if [[ "$2" != "-d" ]]; then
            nmcli c up id "$1";
        fi
    fi
}


newlog () { date "+%y%m%d_%H_%M_%S.log"; }

rpmqlf () { rpm -ql $(rpm -qf $(which $1) | head -n1); }

yum-switch() {
	REPODIR=/etc/yum.repos.d/
	case $1 in
		url)
			ENABLED=baseurl
			DISABLED=mirrorlist
			;;
		list)
			ENABLED=mirrorlist
			DISABLED=baseurl
			;;
		*)
			echo "Usage: $0 <url|list>"
			exit 0
			;;
	esac

	for F in fedora fedora-updates; do
		sed -i "s/^#$ENABLED/$ENABLED/" $REPODIR$F.repo
		sed -i "s/^$DISABLED/#$DISABLED/" $REPODIR$F.repo
	done
}

ssj () {
    ssh -i ~/.ssh/rhos-jenkins \
        -o PreferredAuthentications=publickey,password \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        "$@";
}

scpvm() {
    scp -i ~/.ssh/rhos-jenkins \
        -o PreferredAuthentications=publickey,password \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o User=root "$@" ;
}
sshvnc() {
    if ssh -4 -f -L 5901:localhost:5900 "$@" 'x11vnc -once -nopw -localhost -display :0'; then
        # -ncache 10 
        sleep 0.3;
        vncviewer -PreferredEncoding zlib -QualityLevel 5 -CompressLevel 6 localhost:5901;
    fi
}

git-personal() {
    git status &> /dev/null || return;
    git config --local user.name "Queria Sa-Tas";
    git config --local user.email "public@sa-tas.net";
}
git-unpersonal() {
    git status &> /dev/null || return;
    git config --local --unset user.name;
    git config --local --unset user.email;
}

venv() {
    local selected="/all/src/.venv-${1}/bin/activate"
    if [[ -z "$1" || "$1" = "--help" || ! -f "$selected" ]]; then
        echo "Available venvs:";
        ls -1d /all/src/.venv-*|sed 's/.*\.venv-/ /';
        return;
    fi;
    source "$selected";
    if command -v rehash &> /dev/null; then
        rehash
    fi
}
oslogs() {
    [[ -f ~/.oslogs.cfg ]] && . ~/.oslogs.cfg
    if [[ "$1" = "--help" || -z "$1" ]]; then
        echo "Usage:"
        echo "  oslogs <job-name/buildN> [tgz-file-name]"
        return 1
    fi
    if [[ "$1" = "-v" ]]; then
        shift
        set -x
    fi
    JOBBUILD="$1"
    ARCHIVE="${2:-undercloud-0.tar.gz}"

    # strip url prefix
    JOBBUILD="${JOBBUILD##http*\/job\/}"
    # strip trailing slash
    JOBBUILD="${JOBBUILD%\/}"

    JENKINS_URLPREF="${1%${JOBBUILD}}"
    JENKINS_URLPREF="${JENKINS_URLPREF:-${JENKINS_URL:-https://rhos-qe-jenkins.rhev-ci-vms.eng.rdu2.redhat.com}}"

    DEST="${TMPDIR:-/tmp}/jenkins-log.${JOBBUILD//\//_}"
    DEST_FILE="${DEST}/${ARCHIVE}"
    DEST_DIR="${DEST}/${ARCHIVE%.tar.gz}"

    if [[ -d "$DEST" ]]; then
        echo "Directory '$DEST' already exists, reusing ..."
    fi
    mkdir -p "$DEST"


    if [[ -f "$DEST_FILE" ]]; then
        echo "Archive $ARCHIVE already present, reusing ..."
    else
        curl --insecure --fail --location "${JENKINS_URLPREF}/job/${JOBBUILD}/artifact/${ARCHIVE}" -o "${DEST_FILE}"
    fi

    cd "$DEST"
    if [[ -d "$DEST_DIR" ]]; then
        echo "Unpacked directory $DEST_DIR already present, nothing to do ..."
    else
        tar xf "$ARCHIVE"
    fi
    cd "$DEST_DIR"
}


gercd() {
    local tgt="$(
    find /all/ptmp/gertty-repos/ \
        -maxdepth 3 \
        -type d \
        -iname "*$1*" | head -n1)"
    cd $tgt
}

if [[ -f ~/.bash_aliases_mv ]]; then
    mv2arch_single () {
        . ~/.bash_aliases_mv # obtain mv2arch_{host,path} variables
        F="${1}"
        if [ ! -f "${F}" ]; then
            echo "FILE '${F}' NOT FOUND!"
            continue
        fi
        OF=$(basename "${F}")
        scp "${F}" $mv2arch_host:$mv2arch_path && rm "${F}"
        ssh $mv2arch_host "chmod 644 '$mv2arch_path/${OF}'"
    }

    mv2arch()
    {
        if [[ -z "$*" ]]; then
            readarray -t FILES
            for FIDX in ${!FILES[*]}; do
                mv2arch_single "${FILES[$FIDX]}"
            done ;
        else
            for F in "$@"; do
                mv2arch_single "$F"
            done ;
        fi
    }
fi

preloadstate() {
    journalctl -a -t rc.local -b -0 --follow;
}



light() { dyncol switch queria-dark; }
dark() { dyncol switch queria; }
poekill() { pkill PathOfExile.exe; }
noretry() { find -name \*.retry -print -delete; }
xmls-from-jjb () { rm -rf /tmp/xmls; mkdir -p /tmp/xmls; jenkins-jobs test -o /tmp/xmls .; }
gamekeeper() { rustsrv_stat.py 91.121.90.23 28025; }
