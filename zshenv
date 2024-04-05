# -*-conf-*-
# This file is sourced in all ZSH instances, including every
# interactive and non-interactive shells.

# Load .zsh_private if it exists
if [[ -f ~/.zsh_private ]]; then
  source ~/.zsh_private
fi


# Set PATH
# `/usr/bin/vendor_perl`: biber
# `$HOME/.local/bin`: ?
PATH="$PATH:/usr/bin/vendor_perl:/home/makmiller/scripts/myscripts"
if [ -d /opt/cuda/bin ]; then
    PATH="$PATH:/opt/cuda/bin"
fi
export PATH


# CUDA vars
if command -v nvcc >/dev/null 2>&1; then
    export NVCC_PREPEND_FLAGS='-ccbin /opt/cuda/bin'
    export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH
    export CUDA_VISIBLE_DEVICES=0
fi