# Config for interactive shell sessions.
# !ln -s %:p ~/.zshrc
#
# zsh/zprof is used to profile the shell startup time.

# zmodload zsh/zprof

## USE SANER DEFAULTS ---------

setopt NO_BEEP	      # disable beeping
setopt ignore_eof     #
setopt extended_glob  # turn on more powerful pattern matching features
setopt correct	      # enable correction commands typed
setopt notify	        # notify when jobs finish
setopt auto_cd	      # don't require typing cd to change directories
setopt NO_HUP	        # don't kill jobs when shell exits
# setopt COMPLETE_ALIASES # autocomplete aliases

# Map HOME, END, and DEL keys
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "\e[3~" delete-char

## Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load colors
autoload -U colors
colors


## HISTORY --------

# History settings
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
HISTDUP=erase # Erase duplicates

setopt appendhistory
setopt share_history  # share history between shell instances
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


## COMPLETION ------

# Enable compinit
autoload -U compinit
compinit

# Use internal pager to display matches
zmodload zsh/complist
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
bindkey -M listscroll q send-break # q exits internal pager

# Saner completion behavior
# zstyle ':completion:*' menu select # activate menu selection
zstyle ':completion:*' rehash true # rehash automatically
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
# zstyle ':completion:*' format '%B---- %d%b'
# zstyle ':completion:*:descriptions' format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'
# zstyle ':completion:*:messages' format '%B%U---- %d%u%b'
# zstyle ':completion:*:warnings' format "%B$fg[red]%}---- no match for: $fg[white]%d%b"

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

# Enable fzf if it is installed
if command -v fzf >/dev/null 2>&1; then
    # Enable fzf keybindings and completion
    # C-t: pasted file/dir onto the command line.
    # M-c: cd into selected directory.
    # C-r: search history. Press C-r again to search by chronological order.
    source <(fzf --zsh)
    # Change trigger so that it doesn't conflict with zsh
    export FZF_COMPLETION_TRIGGER=',,'
fi

# Enable zoxide if it is installed
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi

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


## PLUGINS ----------

# Path to your oh-my-zsh installation
ZSH=/usr/share/oh-my-zsh/

# Path to custom plugins
ZSH_CUSTOM=/usr/share/zsh/

# Set theme
ZSH_THEME="powerlevel10k/powerlevel10k"

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
plugins=(fzf-tab zsh-syntax-highlighting zsh-vi-mode zsh-autosuggestions copypath direnv)

ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh


# fzf-tab
# Force zsh not to show completion menu, which allows fzf-tab to capture the
# unambiguous prefix
zstyle ':completion:*' menu no

# Switch between groups with < and >
zstyle ':fzf-tab:*' switch-group '<' '>'

# Continuous trigger key
zstyle ':fzf-tab:*' continuous-trigger '/'

# Keybindings for completions
# Insert mode
function zvm_after_init() {
   zvm_bindkey viins '^R' fzf-history-widget
   zvm_bindkey viins '^[^f' forward-word
}
# bindkey '' autosuggest-accept # zsh-autosuggestions
# bindkey '' expand-or-complete-prefix # vanilla autosuggestions


## PROMPT ----------
# Source Powerlevel10k if file exists
# Run `p10k configure` to customize prompt
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

## ALIASES ---------

# Default applications
alias o="xdg-open"

# Wrapper to change cwd when exiting yazi
# From https://yazi-rs.github.io/docs/quick-start
function oh() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# ls
if command -v eza >/dev/null 2>&1; then
  alias ll="eza --color=always --all --long --git --no-user"
  alias ls="eza --color=always --all --long --git --no-user --no-permissions --no-filesize --icons=always --no-time"
fi


# Assistants
alias a="sgpt --model '${OPENAI_BASIC}' --temperature 1 "
alias aa="sgpt --model '${OPENAI_ADVANCED}' --temperature 1 "
alias ar="assistant_reasoning.py"
alias ao="assistant_online-search.py"

# Editor
alias e="nvim "
alias eh="nvim ."
alias ef="run_fzf-on-files-and-dirs.sh"
alias eg="run_rg.sh"

# Git
alias gg="lazygit"

alias cg="cd \$(git rev-parse --show-toplevel)"  # cd to root git repo

alias gs="git status --short -b"
alias gS="check-git-repos-status-recursive.sh"

alias gss="git submodule foreach 'git status --short'"
alias gsa="git submodule add "
alias gsi="git submodule update --init --recursive" # commit specified by the parent repo
alias gsu="git submodule update --remote --recursive" # latest commit

alias gf="git fetch --all"
alias gfs="git fetch --all && git show HEAD..FETCH_HEAD"
alias gfg="git fetch --all && git graph HEAD..FETCH_HEAD"

alias gp="git pull"
alias gps="git pull --recurse-submodules"
alias gpr="git pull --rebase"

alias gb="git branch --all"
alias gbn="git checkout -b "
alias gbd="git branch -D "
alias gbD="git push origin --delete "

alias ga="git add"
alias gac="git commit -a "

alias gc="git commit "
alias gca="git commit --amend --no-edit"
alias gcA="git commit --amend"

alias gd="git diff --submodule"
alias gds="git diff --staged --submodule"

alias gl="git log -p --submodule"

function git_clean_confirm() {
 git clean -fd --dry-run
 echo
 read "REPLY?Proceed with git clean -fd? (y/n): "
 if [[ $REPLY =~ ^[Yy]$ ]]; then
   git clean -fd
 else
   echo "git clean -fd aborted."
 fi
}
alias gC="git_clean_confirm"

alias gr="git reset "
alias grh="git reset HEAD" # unstage changes in the staging area
alias grH="git reset --hard HEAD" # reset repo to the last commit


# Package manager
alias pu="sudo pacman -Syu"
alias pU="yay -Sua --devel"
alias pL="pacman -Qm"
alias pc="yay -Sc"

# Convert between file formats
alias cmh="convert_md_to_html.py"
alias cms="pandoc -i -t revealjs -s "
alias com="pandoc -t gfm -f org "

# zprof
