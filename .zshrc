# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="candy"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(autojump bgnotify chucknorris history-substring-search lol python screen zsh-autosuggestions zsh-syntax-highlighting)

# User configuration

source $ZSH/oh-my-zsh.sh

##### Snippets from plugins where there is some issue (for me)
##### or i want different behaviour
#
# run chucknorris at start of new term
fortune -a $ZSH/plugins/chucknorris/fortunes
#
# Make zsh know about hosts already accessed by SSH (i don't want rest of the common-aliases)
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
###########

zle-line-init() {
    zle autosuggest-start
}
zle -N zle-line-init
AUTOSUGGESTION_ACCEPT_RIGHT_ARROW=1

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# ↳↘⇒⇢⇨⇰⇶⇾↠↣↦∅∈ ∟∫∮∴≃≣
export PROMPT=$' ≣ $(last_exit_code) \
'"$PROMPT"
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

setopt NO_HUP
setopt HISTIGNORESPACE

[ -z "$ZSH_CDHOME" ] && export ZSH_CDHOME=1 && cd $HOME

bgnotify_formatted () {
    [ $1 -eq 0 ] && title="#success (took $3 s)"  || title="#fail (took $3 s)"
    notify-send -a zsh "$title" "$2"
    #bgnotify "$title" "$2"
}
git_prompt_info () {
    local ref
    local stashed
    ref=$(command git symbolic-ref HEAD 2> /dev/null)  || ref=$(command git rev-parse --short HEAD 2> /dev/null)  || return 0
    stashed="$(git stash list 2>/dev/null| wc -l)"
    [[ $stashed -gt 0 ]] && stashed="+$stashed" || stashed=""
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}${stashed}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

last_exit_code () {
    local last=$?
    if [[ $last = 0 ]]; then
        echo "%{$fg[green]%}${last}%{$reset_color%}"
    elif [[ $last -gt 128 ]]; then
        local sign=$(( $last - 128 ))
        local signame
        signame=$(sed -rn 's/#define\s+SIG(.*)\s+'$sign'/\1/p' /usr/include/asm/signal.h 2>/dev/null)
        echo "%{$fg[red]%}${last} ${sign}=${signame}%{$reset_color%}"
    else
        echo "%{$fg[magenta]%}${last}%{$reset_color%}"
    fi
}
