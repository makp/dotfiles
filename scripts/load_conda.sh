#!/bin/bash

#
# Procedures for initializing conda in zsh
#

# Workaround for the issue with miniconda
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

# Select conda env to be activated
DEFAULT_CONDA_ENV="ml"
CONDA_NEW_ENV="${1:-$DEFAULT_CONDA_ENV}"

# Execute conda for Zsh and capture the ouput
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"

# If previous command was successful, eval the returned setup cmds.
# Otherwise, source the conda.sh script if it exists or add conda to the PATH
if [ $? -eq 0 ]; then # check if previous command was successful
  echo "Setup worked!"
  eval "$__conda_setup"
else
  if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
    source "/opt/miniconda3/etc/profile.d/conda.sh"
  else
    export PATH="/opt/miniconda3/bin:$PATH"
  fi
fi

# Activate the selected env
conda activate $CONDA_NEW_ENV

# Del temp shell var
unset __conda_setup
