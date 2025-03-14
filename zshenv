# Environment variables for ZSH
# !ln -s %:p ~/.zshenv
#
# This file is sourced in all ZSH instances, including every
# interactive and non-interactive shells.

# Load .zsh_private if it exists
if [[ -f ~/.zsh_private ]]; then
	source ~/.zsh_private
fi

# Path to config files
export CONFIG_FILES="$HOME/Documents/mydocs/config_files"

# PATH
# `/usr/bin/vendor_perl`: biber
PATH="$PATH:/usr/bin/vendor_perl:$CONFIG_FILES/scripts:$HOME/Documents/mydocs/teaching/teaching_admin/teaching_utils:$HOME/.luarocks/bin:"
if [ -d /opt/cuda/bin ]; then
	PATH="$PATH:/opt/cuda/bin"
fi
export PATH


# Default editors for ZSH
# EDITOR is for programs that expect a line editor.
# VISUAL is for screen-oriented programs.
export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim
export ALTERNATE_EDITOR=vim

# Pager for `man`
export MANPAGER="nvim +Man!"

# rclone
export RCLONE_FAST_LIST=true

# Git
export GIT_AUTHOR_NAME="mak-$(hostname)"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"

# AI models
export OPENAI_BASIC="gpt-4o-mini"
export OPENAI_ADVANCED="gpt-4o"
export OPENAI_REASON_MINI="o3-mini"
export OPENAI_REASON="o1-preview"
export PPLX_BASIC="sonar"
export PPLX_ADVANCED="sonar-pro"
export PPLX_REASON_BASIC="sonar-reasoning"
export PPLX_REASON_ADVANCED="sonar-reasoning-pro"
export ANTHROPIC_MODEL="claude-3-7-sonnet-latest"

# CUDA vars
if command -v nvcc >/dev/null 2>&1; then
	export NVCC_PREPEND_FLAGS='-ccbin /opt/cuda/bin'
	export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH
	export CUDA_VISIBLE_DEVICES=0
fi

# ssh-agent socket
# The ssh-agent should have been started as a systemd user unit
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
