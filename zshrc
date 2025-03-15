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
# `light` (instead of `load`): sans report
# `lucid`: non-verbose
# `ice`: provides modifier next cmd
source /usr/share/zinit/zinit.zsh

# Path to plugins
PATH_OMZ=/usr/share/oh-my-zsh/plugins # Oh My Zsh plugins
PATH_PLUGINS=/usr/share/zsh/plugins

# Source config files in zshrc.d
for config_file ($USER_CONFIG_FILES/zshrc.d/*.zsh(N)) ; do
 source "$config_file"
done

# zprof
