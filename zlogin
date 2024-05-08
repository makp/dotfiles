# -*-conf-*-
# This file is only sourced in login shells. Because of this, it
# focuses on processes that should happen at the start of the login
# shell session.


## OpenSSH KEYS PASSPHRASES -------

# Ask for OpenSSH keys if none has been added
if [[ -n $SSH_AUTH_SOCK ]] && ! ssh-add -l > /dev/null; then
    unset SSH_ASKPASS		# don't use a graphical prompt
    ssh-add
    case "$(hostname)" in
	"leibniz")
	    key_path="$HOME/.ssh/leibniz_rsa"
	    ;;
	"turing")
	    key_path="$HOME/.ssh/turing_rsa"
	    ;;
	"tarski")
	    key_path="$HOME/.ssh/tarski_rsa"
	    ;;
	*)
	    echo "Hostname not recognized. SSH key not added."
	    return 1 		# exit with error status
	    ;;
    esac

    if [[ -f "$key_path" ]]; then
	ssh-add "$key_path"
    else
	echo "Key file not found: $key_path"
    fi
fi


## SET UP CONDA ------
if [[ -z "$CONDA_INITIALIZED" ]]; then
    echo "Initializing conda..."
    source load_conda.sh
    conda activate ml
fi
