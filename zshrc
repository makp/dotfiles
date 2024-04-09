# -*-conf-*-
# Config for interactive shell sessions.

# zmodload zsh/zprof

## USE SANER DEFAULTS ---------

setopt NO_BEEP	      # disable beeping
setopt ignore_eof     # 
setopt extended_glob  # turn on more powerful pattern matching features
setopt correct	      # enable correction commands typed
setopt notify	      # notify when jobs finish
setopt auto_cd	      # don't require typing cd to change directories
setopt NO_HUP	      # don't kill jobs when shell exits
# setopt COMPLETE_ALIASES # autocomplete aliases

# Map HOME, END, and DEL keys
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "\e[3~" delete-char

bindkey "^[h" backward-kill-word # M-h

# Enable vi mode
bindkey -v


# For ZSH, not just alphanumerics are part of a word, but other
# symbols stated by the shell variable WORDCHARS. Making this
# variable empty reproduce bash behavior. 
# WORDCHARS=*?_-.[]~=/&;!#$%^(){}<>  # default value
# export WORDCHARS="?[]~=&;!#$%^(){}<>"  # removed symbols *./-_

## HISTORY --------

# Use C-n and C-p to navigate history
bindkey "^[n" down-line-or-history
bindkey "^[p" up-line-or-history

# History settings
HISTSIZE=2000
SAVEHIST=2000
HISTFILE=~/.zsh_history

setopt hist_ignore_all_dups 
setopt hist_ignore_space
setopt share_history  # share history between shell instances


# Max directory stack size
# DIRSTACKSIZE=33  

# Directory stack behavior (pushd/popd)
# setopt autopushd  # make cd always behave like pushd
setopt pushd_ignore_dups # disable multiple copies same dir in the directory stack
# setopt pushd_silent # don't print the directory stack after pushd or popd


## PLUGINS ----------

# Path to your oh-my-zsh installation
ZSH=/usr/share/oh-my-zsh/

# Path to custom plugins
ZSH_CUSTOM=/usr/share/zsh/

# Set theme
# ZSH_THEME="robbyrussell"

# Use case-sensitive completion.
# CASE_SENSITIVE="true"

# Use hyphen-insensitive completion
# HYPHEN_INSENSITIVE="true"

# Just remind me to update when it's time
zstyle ':omz:update' mode reminder

# Enable auto-correction
ENABLE_CORRECTION="true"

# Display red dots whilst waiting for completion
# COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
COMPLETION_WAITING_DOTS="true"

# Vars for vi-mode plugin
VI_MODE_SET_CURSOR=true
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true

# Enable some plugins
plugins=(fzf-tab zsh-syntax-highlighting vi-mode zsh-autosuggestions copypath dirpersist)

ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh


## COMPLETION ------

# Enable fzf if it is installed
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --zsh)"  # fzf keybindings and fuzzy completion
    export FZF_COMPLETION_TRIGGER=',,'
fi

# Use internal pager to display matches
zmodload zsh/complist		 
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
bindkey -M listscroll q send-break # q exits internal pager

# Enable compinit
autoload -U compinit
compinit

# Saner completion behavior 
zstyle ':completion:*' rehash true # rehash automatically
zstyle ':completion:*' menu select # activate menu selection
zstyle ':completion:*' verbose yes # print descriptions against each match
zstyle ':completion:*' group-name '' # separate matches in distinct related groups
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} # applies color scheme LS_COLORS
zstyle ':completion:*:*:*:*:processes' force-list always # even if there is only one possible completion
zstyle ':completion:*:cd:*' ignore-parents parent pwd # never suggest parent dir


# Enable zstyle caching (for speed)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Customize format during completion
# `%B` and `%b` are used to make the text that appears between them
# bold. %U` and `%u` are used to underline the text between them. `%d`
# is replaced with the description of the group.
zstyle ':completion:*' format '%B---- %d%b'
zstyle ':completion:*:descriptions' format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}' 
zstyle ':completion:*:messages' format '%B%U---- %d%u%b' 
zstyle ':completion:*:warnings' format "%B$fg[red]%}---- no match for: $fg[white]%d%b"


# Customize fuzzy matching
zstyle ':completion:*' completer _expand_alias _complete _match _approximate # used completion funcs
# zstyle ':completion:*' special-dirs true
zstyle ':completion:*:match:*' original only # disable transformation features
zstyle ':completion:*:approximate:*' max-errors 1 numeric # max number of typos numeric args
zstyle -e ':completion:*:approximate:*' \
    max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3)))' # max number of errors
# The number of errors allowed increase with the length of what you have typed so far


# Customize auto-completion at specific contexts
zstyle ':completion:*:*:*:*:processes' insert-ids menu yes select # process IDs
zstyle ':completion:*:processes' command 'ps c -u ${USER} -o pid,%cpu,cputime,cmd'  # name completion
# alternative completions: tty #'ps -U $(whoami) | sed "/ps/d"'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31' # kill
zstyle ':completion:*:manuals' separate-sections true # manpages
zstyle ':completion:*:manuals.*' insert-sections true

# Use CDPATH for completion
# The nullstring "::" forces cd to search in the working directory
# This is important because, without it, cd will only search the working
# directory after the other directories in CDPATH fails. 
# export CDPATH=$HOME
export CDPATH=::$HOME/Documents/mydocs/:$HOME/config-files/general

# Autocompletion for PDFs
# Open the most recently modified PDF file in the current directory by
# default, if no parameter is given. It also configures completion for
# this function to use a menu selection and sorts files by
# modification time.
okular() { command okular ${*:-*.pdf(om[1])} }
zstyle ':completion:*:*:okular:*' menu yes select
zstyle ':completion:*:*:okular:*' file-sort time

# Enable the predict feature
# autoload predict-on
# predict-on

zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' continuous-trigger '/'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'


# Enable ShellGPT completions
_sgpt_zsh() {
if [[ -n "$BUFFER" ]]; then
    _sgpt_prev_cmd=$BUFFER
    BUFFER+="⌛"
    zle -I && zle redisplay
    BUFFER=$(sgpt --shell <<< "$_sgpt_prev_cmd" --no-interaction)
    zle end-of-line
fi
}
zle -N _sgpt_zsh
bindkey '^ ' _sgpt_zsh

alias c='sgpt '
alias cc="sgpt --model 'gpt-4-turbo-preview' "
# bindkey '' autosuggest-accept # from zsh-autosuggestions
# bindkey '' expand-or-complete-prefix # vanilla autosuggestions


## APPEARANCE ----------

# Load colors
autoload -U colors 
colors

# Set command prompt
autoload -Uz vcs_info
setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats "%{$fg_bold[green]%}%s %r %{$fg_no_bold[green]%}[%b] %{$fg_bold[magenta]%}%m%u%c%{$reset_color%} "
# zstyle ':vcs_info:git:*' actionformats ' [%b|%s|%a]'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' untrackedstr '%'

precmd_functions+=('vcs_info_pre')
function vcs_info_pre() {
  vcs_info
  PS1="
%{$fg[white]%}@%m (%*) %{$fg_bold[yellow]%}%1~/%{$reset_color%} \${vcs_info_msg_0_}%{$reset_color%}
> "
}


# zprof