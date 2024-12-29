#
# Vi mode
#

# FIXME: Vi mode prevents Ctrl-F from accepting autosuggestions

# Enable vi mode
set -g fish_key_bindings fish_vi_key_bindings

# Emulates vim's cursor shape behavior
set fish_cursor_default block # Set normal and visual mode cursors to a block
# set fish_cursor_visual block
set fish_cursor_insert line # Set the insert mode cursor to a line
set fish_cursor_replace_one underscore # Set the replace mode cursors to an underscore
set fish_cursor_replace underscore
set fish_cursor_external line # The external cursor appears when a command is started.

# Enable zoxide
zoxide init --cmd cd fish | source

# Enable fzf
fzf --fish | source
