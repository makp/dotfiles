#!/bin/bash
alacritty --title 'term_scratchpad' \
  --option window.dimensions.columns=88 \
  --option window.dimensions.lines=14 \
  --option window.opacity=0.94

#
# --command zsh -c 'tmux attach -d'
#
#
# kitty --title="term_scratchpad" \
#   -o remember_window_size=n \
#   -o initial_window_height=14c \
#   -o initial_window_width=88c
