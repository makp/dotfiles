# -*-conf-*-
# This file is only sourced in login shells. Because of this, it
# focuses on processes that should happen at the start of the login
# shell session.

# Start ssh-agent (from Arch Linux page on ssh keys)
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
