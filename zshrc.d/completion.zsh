# fzf keybindings:
# C-t: pasted file/dir onto the command line.
# M-c: cd into selected directory.
# C-r: search history. Press C-r again to search by chronological order.

# CASE_SENSITIVE="true" # Use case-sensitive completion.
# HYPHEN_INSENSITIVE="true" # Use hyphen-insensitive completion

ZOXIDE_CMD_OVERRIDE="cd"

#
zinit wait lucid light-mode for \
  $PATH_OMZ/zoxide/ \
  $PATH_OMZ/fzf/

# Change fzf trigger key
export FZF_COMPLETION_TRIGGER=',,'

# bindekey -M viins '^R' fzf-history-widget

# Bind `Ctrl+Alt+/` to zoxide interactive mode
zoxide_query() {
  cdi
  zle accept-line # Simulate pressing Enter
}
zle -N zoxide_query
bindkey '^[^_' zoxide_query

#
# Configure completion style (zstyle)
# Source: https://github.com/Aloxaf/fzf-tab?tab=readme-ov-file#configure
#
# Rehash automatically
zstyle ':completion:*' rehash true
# Disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# Set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# Set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# Use custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
# zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
# Force zsh not to show completion menu
zstyle ':completion:*' menu no
# Switch between groups with < and >
zstyle ':fzf-tab:*' switch-group '<' '>'
# Continuous trigger key for fzf-tab
zstyle ':fzf-tab:*' continuous-trigger '/'

# Define a custom widget for alias expansion without triggering fzf-tab
expand-alias-only() {
  zle _expand_alias
  zle redisplay
}

zle -N expand-alias-only # Register the widget
bindkey '^ ' expand-alias-only


# Load remaining plugins with a delay
# Consider using fast-syntax-highlighting
zinit wait"1" lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
  $PATH_PLUGINS/fzf-tab-git \
  atload"_zsh_autosuggest_start" \
  "$PATH_PLUGINS/zsh-autosuggestions/" \
  "$PATH_PLUGINS/zsh-syntax-highlighting/"

bindkey -M viins '^[^f' forward-word
bindkey -M viins '^f' autosuggest-accept

# bindkey '' expand-or-complete-prefix # vanilla autosuggestions
