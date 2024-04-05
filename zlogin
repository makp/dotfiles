# -*-conf-*-
# This file is only sourced in login shells. Because of this, it
# focuses on processes that should happen at the start of the login
# shell session.

# Make sure ssh-agent is running (from Arch Linux page on ssh keys)
# This will run a ssh-agent process if there is not one already, and
# save the output thereof. If there is one running already, we
# retrieve the cached ssh-agent output and evaluate it which will set
# the necessary environment variables.
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
    eval "$(<"$XDG_RUNTIME_DIR/ssh-agent.env")"
fi


# Ask for OpenSSH keys
if [[ -n $SSH_AUTH_SOCK ]]; then
    unset SSH_ASKPASS		# don't use a graphical prompt
    ssh-add
    case "$(hostname)" in
        "leibniz")
	    key_path="$HOME/.ssh/leibniz_rsa"
	    ;;
        "turing")
            key_path="$HOME/.ssh/turing_rsa"
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
