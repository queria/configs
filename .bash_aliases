# vim: syn=sh:et:ts=4:sw=4

export GREP_COLOR=31

[[ "$SHELL" != "/usr/bin/zsh" ]] && unalias -a

alias grep='grep --color=auto'
alias less='less -r'
alias more='less'
alias v='vim'
alias vv='view'

export PAGER='less'
#export PAGER='view'
alias | grep -q '^\(alias \)\?ls=' && unalias ls
alias | grep -q '^\(alias \)\?ll=' && unalias ll
alias ls="ls --color=auto"
alias cal='cal -m'

g () { grep "$@" ./*; }
topp () { top -n 1; }
ll () { ls -lha --group-directories-first "$@" ; }
lls () { ll "$@" | less; }
lg () { ( ( [ -z "$2" ] && ll ) || ll "$2" ) | grep -i "$1"; }
lt () { ll -tr "$@"; }
lll () { ll -tr "$@"|tail; }
llS () { ll -Sr "$@"|tail; }
psg () { ps -ef | grep -v 'grep' | grep -i "$@"; }
scrr () { screen -d -R $@; }
tmx () { tmux has &>/dev/null && tmux attach -d -t 0 || tmux ; }
cdl () { cd "$1" && ll; }
cds () { cd /all/src/$1; }
cdt () { cd /all/tmp; }
cdtl () { cd /all/tmp; lll "$@"; }

vw () { FILES=$(which "$@"); if [ "x$FILES" != "x" ]; then vim -p "$FILES"; fi; }
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
        [[ -e "${subs}" ]] && opts=("${opts[@]}" "-sub" "${subs}")
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
        echo "mplayer -sub \"${subs}\" \"${lastffinal}\"";
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

alias gg='git grep'

sshvirt () {
    while ! ping -w 1 -c 1 virt &>/dev/null; do
        echo -n .
        sleep 1
    done
    if ssh virt 'exit'; then
        clear
        ssh virt
    else
        echo "host up, incoming ssh"
        for N in $(seq 10 -1 0); do
            echo -ne "\r$N  "
            sleep 0.5
        done
        clear
        ssh virt
    fi;
}

scpvm() {
    scp -i ~/.ssh/rhos-jenkins \
        -o PreferredAuthentications=publickey,password \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o User=root "$@" ;
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

oslogs() {
    local CWDBEFORE="$(pwd)"
    [[ -f ~/.oslogs.cfg ]] && . ~/.oslogs.cfg
    # put 'local VAR=value' lines in the config
    local LOGS="${LOGS:-/all/tmp/oslogs}"
    local LOGS_SRC="${LOGS_SRC:-/all/tmp}"
    local PATT="${PATT:-logs-jenkins*.tar.bz2}"
    local ITER=""
    local DIRNAME=""
    local SINGLE=""
    local FILES=""
    local NEWNAME=""


    if [[ "$1" == "cd" ]]; then
        DOCD="yes"
        shift
    fi
    if [[ ! -z "$1" ]]; then
        NEWNAME="$1"
        shift
        if [[ -e "${LOGS}/${NEWNAME}" ]]; then
            echo "Unable to use $NEWNAME as name for extracted oslogs."
            echo "${LOGS}/${NEWNAME} already exists!"
            exit 1
        fi
        echo "Will try to rename to ${NEWNAME}"
    fi


    if [[ "${DOCD}" == "yes" ]]; then
        CWDBEFORE="${LOGS}"
    fi


    mkdir -p "$LOGS"
    cd "$LOGS_SRC"

    FILES="$(ls -1 $PATT)"
    for ITER in $FILES; do
        echo "New logs $ITER"
        mv "$ITER" "$LOGS"
    done
    [[ -z "$FILES" ]] && echo "No newly downloaded logs"


    cd "$LOGS"

    mkdir -p _archive;

    FILES="$(ls -1 $PATT)"
    for ITER in $FILES; do
        tar xf "$ITER";
        mv "$ITER" _archive
        DIRNAME="${ITER%.tar.bz2}"
        chmod u+w $DIRNAME/*/root
        if [[ -z "$SINGLE" ]]; then
            SINGLE="$DIRNAME"
        else
            SINGLE="-multiple-"
        fi
    done
    [[ -z "$FILES" ]] && echo "No logs to uncompress"

    if [[ ! -z "$SINGLE" && "$SINGLE" != "-multiple-" ]]; then
        if [[ ! -z "$NEWNAME" ]]; then
            echo "renaming $SINGLE => $NEWNAME"
            mv "$SINGLE" "$NEWNAME"
            SINGLE="$NEWNAME"
        fi
        cd "$SINGLE"
        pwd
    else
        cd "$CWDBEFORE"
    fi
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
