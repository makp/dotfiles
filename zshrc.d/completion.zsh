#
# Configure ZSH completion
#

# Enable autocomplete
autoload -Uz compinit
compinit

# Enable autocompletion interface (double tab)
zstyle ':completion:*' menu select

# Rehash automatically
zstyle ':completion:*' rehash true

# Set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'

# Set list-colors to enable filename colorizing
autoload -U colors && colors
if [[ -z "$LS_COLORS" ]]; then # Make sure LS_COLORS is set
    eval "$(dircolors -b)"
fi
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Cache completion for better performance
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

# Never suggest parent dir
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# Fuzzy matching of completions
# Specify completion funcs
zstyle ':completion:*' completer _expand_alias _complete _match _approximate

#
# zstyle ':completion:*:match:*' original only

# Make the num of errors increase with the length of what you have typed
zstyle -e ':completion:*:approximate:*' \
    max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3)))' # max number of errors

#
# fzf and zoxide
#

# fzf keybindings:
# C-t: pasted file/dir onto the command line.
# M-c: cd into selected directory.
# C-r: search history. Press C-r again to search by chronological order.

# CASE_SENSITIVE="true" # Use case-sensitive completion.
# HYPHEN_INSENSITIVE="true" # Use hyphen-insensitive completion

ZOXIDE_CMD_OVERRIDE="cd"

#
zinit light-mode for \
  $PATH_OMZ/zoxide/ \
  $PATH_OMZ/fzf/

# Change fzf trigger key to avoid conflict with `**`
export FZF_COMPLETION_TRIGGER=',,'

# Add key to run fzf without trigger char
fzf-completion-widget() {
    LBUFFER="${LBUFFER},,"
    zle fzf-completion
}
zle -N fzf-completion-widget
bindkey '^[f' fzf-completion-widget # Alt-f


# bindekey -M viins '^R' fzf-history-widget

# Bind `Ctrl+Alt+/` to zoxide interactive mode
zoxide_query() {
  cdi
  zle accept-line # Simulate pressing Enter
}
zle -N zoxide_query
bindkey '^[^_' zoxide_query
bindkey -M vicmd '^[^_' zoxide_query # normal mode


#
# Load remaining plugins with a delay
#

# The cmds `atinit` and `atload` are used to run commands before and after
# loading the plugin
zinit wait"1" lucid light-mode for \
  atload"_zsh_autosuggest_start" \
  "$PATH_PLUGINS/zsh-autosuggestions/" \
  "$PATH_PLUGINS/zsh-syntax-highlighting/"

bindkey -M viins '^[^f' forward-word
bindkey -M viins '^f' autosuggest-accept

# bindkey '' expand-or-complete-prefix # vanilla autosuggestions
