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
plugins=(autojump bgnotify lol gitfast python screen zsh-syntax-highlighting history-substring-search)
# zsh-autosuggestions

# User configuration

source $ZSH/oh-my-zsh.sh

##### Snippets from plugins where there is some issue (for me)
##### or i want different behaviour
#
# run chucknorris at start of new term
#fortune -a $ZSH/plugins/chucknorris/fortunes
#
# Make zsh know about hosts already accessed by SSH (i don't want rest of the common-aliases)
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
###########

#zle-line-init() {
#    zle autosuggest-start
#}
#zle -N zle-line-init
#AUTOSUGGESTION_ACCEPT_RIGHT_ARROW=1

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
unsetopt share_history

# disable bracketed paste (aka safe paste)
# to not get special chars escaped in pasted test
# case: curl '<url-pasted>' to not escape ? or similar
#       as i do always quote whole url myself,
#       and want it consistent with any/all remote machines
unset zle_bracketed_paste

[ -z "$ZSH_CDHOME" ] && export ZSH_CDHOME=1 && cd $HOME

bgnotify_formatted () {
    if [ $1 -eq 0 ]; then
        notify-send -a zsh -u low "#success (took $3 s)" "$2"
    else
        notify-send -a zsh -u normal "#fail (took $3 s)" "$2"
    fi
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
        signame=$(sed -rn 's/#define\s+SIG(.*)\s+'$sign'/\1/p' /usr/include/asm/signal.h 2>/dev/null | head -n1)
        echo "%{$fg[red]%}${last} ${sign}=${signame}%{$reset_color%}"
    else
        echo "%{$fg[magenta]%}${last}%{$reset_color%}"
    fi
}

## selecta based fuzzy-file-path-completion
# found at https://github.com/bedge/dotfiles/commit/a44466cf48bfe6520fa782a1423705aa80e8b3e4
function insert-selecta-path-in-command-line() {
    local selected_path
    # Print a newline or we'll clobber the old prompt.
    echo
    # Find the path; abort if the user doesn't select anything.
    selected_path=$(find * -type f | selecta) || return
    # Append the selection to the current command buffer.
    eval 'LBUFFER="$LBUFFER$selected_path "'
    # Rdraw the prompt since Selecta has drawn several new lines of text.
    zle reset-prompt
}
# Create the zle widget
zle -N insert-selecta-path-in-command-line
# Bind the key to the newly created widget
bindkey "^N" "insert-selecta-path-in-command-line"

source $HOME/.zsh_completion


