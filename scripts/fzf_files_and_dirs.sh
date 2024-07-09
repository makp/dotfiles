#!/usr/bin/env bash

# Define the commands to find directories, files, and both
FIND_DIRS_CMD="fd --type d --strip-cwd-prefix --no-ignore --hidden --exclude .git"
FIND_FILES_CMD="fd --type f --strip-cwd-prefix --no-ignore --hidden --exclude .git"
FIND_FILES_AND_DIRS_CMD="fd --strip-cwd-prefix --no-ignore --hidden --exclude .git"

# Use fzf to select a directory or file
$FIND_FILES_AND_DIRS_CMD | fzf \
  --multi --bind 'enter:become(nvim {+})' \
  --prompt 'All> ' \
  --header 'ALT-D: Dirs / ALT-F: Files / ALT-A: All / ALT-P: Preview' \
  --bind "alt-d:change-prompt(Dirs> )+reload(eval '$FIND_DIRS_CMD')" \
  --bind "alt-f:change-prompt(Files> )+reload(eval '$FIND_FILES_CMD')" \
  --bind "alt-a:change-prompt(All> )+reload(eval '$FIND_FILES_AND_DIRS_CMD')" \
  --bind 'alt-p:toggle-preview' \
  --preview '[[ -d {} ]] && eza -T --level=2 --git --colour=always --icons {} || bat --color=always --style=numbers,header,grid --line-range=:500 {}' \
  --preview-window='hidden' \
  --bind 'ctrl-u:preview-up' \
  --bind 'ctrl-d:preview-down' \
  --height 50% --layout=reverse
