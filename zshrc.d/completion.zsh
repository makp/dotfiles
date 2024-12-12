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
  $PATH_OMZ/fzf/ \
  atinit"zicompinit; zicdreplay" \
    $PATH_PLUGINS/fzf-tab-git/

# Change fzf trigger key
export FZF_COMPLETION_TRIGGER=',,'

# Force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no

# Continuous trigger key for fzf-tab
zstyle ':fzf-tab:*' continuous-trigger '/'

# Switch between groups with < and >
zstyle ':fzf-tab:*' switch-group '<' '>'


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


# Enable autosuggestions and syntax highlighting
# TODO: Consider using fast-syntax-highlighting
zinit wait"1" lucid light-mode for \
  atload"_zsh_autosuggest_start" \
    "$PATH_PLUGINS/zsh-autosuggestions/" \
  "$PATH_PLUGINS/zsh-syntax-highlighting/"

# bindkey '' autosuggest-accept # zsh-autosuggestions
# bindkey '' expand-or-complete-prefix # vanilla autosuggestions
