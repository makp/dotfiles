#!/bin/bash

#
# Funcs for initializing conda in zsh
#

# Workaround for the issue with miniconda
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

function conda_initialize() {
  # Ensure there are no naming conflicts
  unset -f conda_initialize conda # -f is used bc the names are funcs

  # Execute conda for Zsh and capture the ouput
  __conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"

  # If previous command was successful, eval the returned setup cmds.
  # Otherwise, source the conda.sh script if it exists or add conda to the PATH
  if [ $? -eq 0 ]; then # check if previous command was successful
    eval "$__conda_setup"
  else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
      source "/opt/miniconda3/etc/profile.d/conda.sh"
    else
      export PATH="/opt/miniconda3/bin:$PATH"
    fi
  fi
  unset __conda_setup # del temp shell var
}

# Wrap conda command to ensure it is initialized before use
function conda() {
  if [ -z "$CONDA_INITIALIZED" ]; then
    echo "Conda is not initialized. Initializing conda..."
    conda_initialize
    export CONDA_INITIALIZED=1
  fi
  # Execute conda with the given arguments
  command conda "$@"
}
