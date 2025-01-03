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

# Enable zsh-vi-mode
# zsh-vi-mode must be installed via AUR
zinit light "$PATH_PLUGINS/zsh-vi-mode/"

# Add keybindings for completions in insert mode
function zvm_after_init() {
   zvm_bindkey viins '^R' fzf-history-widget
   zvm_bindkey viins '^[^f' forward-word
}

# Map HOME, END, and DEL keys
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "\e[3~" delete-char


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
