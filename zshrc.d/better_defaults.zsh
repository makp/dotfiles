## USE SANER DEFAULTS ---------

setopt NO_BEEP	      # disable beeping
setopt ignore_eof     #
setopt correct	      # enable correction commands typed
setopt notify	        # notify when jobs finish
setopt auto_cd	      # don't require typing cd to change directories
setopt NO_HUP	        # don't kill jobs when shell exits
setopt COMPLETE_ALIASES # autocomplete aliases

ENABLE_CORRECTION="true" # Enable auto-correction


## KEY BINDINGS --------

# Use vi keybindings
bindkey -v
bindkey -M viins '^[^f' forward-word
# viins '^R' fzf-history-widget

# Edit command line with $EDITOR
autoload edit-command-line
zle -N edit-command-line
bindkey -M viins ^E edit-command-line
bindkey -M vicmd ^E edit-command-line


# Map HOME, END, and DEL keys
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "\e[3~" delete-char


## MISC --------

# direnv
zinit light "$PATH_OMZ/direnv/"

# Dynamically set the window title for Alacritty
# Source: <https://wiki.gentoo.org/wiki/Alacritty#Zsh>
if [[ "${TERM}" != "" && "${TERM}" == "alacritty" ]]
then
    precmd()
    {
        # output on which level (%L) this shell is running on.
        # append the current directory (%~), substitute home directories with a tilde.
        # "\a" bell (man 1 echo)
        # "print" must be used here; echo cannot handle prompt expansions (%L)
        print -Pn "\e]0;$(id --user --name)@$(hostname): zsh[%L] %~\a"
    }

    preexec()
    {
        # output current executed command with parameters
        echo -en "\e]0;$(id --user --name)@$(hostname): ${1}\a"
    }
fi


## HISTORY --------

HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
HISTDUP=erase # Erase duplicates

setopt appendhistory
setopt share_history  # share history between shell instances
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
