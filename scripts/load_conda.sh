#!/bin/sh

# Funcs for initializing conda in zsh
# The contents of `conda_initialize_hardcore` was taking too long to
# load. The functions should lazily load the conda environment.

# Workaround for the issue with miniconda
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY = 1

function conda_initialize_hardcore() {
    # Store shell commmands in a variable
    __conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then 	# check if previous command was successful
	eval "$__conda_setup"
    else
	if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
	    . "/opt/miniconda3/etc/profile.d/conda.sh"
	else
	    export PATH="/opt/miniconda3/bin:$PATH"
	fi
    fi
    unset __conda_setup  # del temp shell var
}

function conda_initialize() {
    unset -f conda_initialize conda # -f is used bc the names are funcs
    eval "$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
    export CONDA_INITIALIZED=1
    # Note that, because of the unset line above, `conda` no longer refers to the conda function defined below.
    conda activate ml 		# select env
    conda "$@"
}

function conda() {
    if [ -z "$CONDA_INITIALIZED" ]; then
        conda_initialize "$@"
    else
        echo "Conda not initialized properly. Use the command `conda_initialize_hardcore`."
    fi
}
