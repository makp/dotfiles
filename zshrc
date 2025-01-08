# Config for interactive shell sessions.
# !ln -s %:p ~/.zshrc
#
# - zsh/zprof profiles the shell startup time.
# - Run the cmd `bindkey` to list ZSH keybindings, and `showkey -a` to show
# keycodes.

# zmodload zsh/zprof
#
# Don't perform security checks with `compinit` to speed up shell startup
# ZSH_DISABLE_COMPFIX="true"

# Load ZSH pkg manager (zinit)
source /usr/share/zinit/zinit.zsh

# Path to plugins
PATH_OMZ=/usr/share/oh-my-zsh/plugins # Oh My Zsh plugins
PATH_PLUGINS=/usr/share/zsh/plugins

# Source config files in zshrc.d
for config_file ($CONFIG_FILES/zshrc.d/*.zsh(N)) ; do
 source "$config_file"
done

## EXTRA PLUGINS ----------
# Plugins that don't need to be loaded quickly

# Load `direnv`
zinit wait"1" lucid light-mode for \
  "$PATH_OMZ/direnv/"

# zprof
