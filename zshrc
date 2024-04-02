# -*-conf-*-
# ~/.zshrc
# In order to change the default shell, use: usermod -s /bin/<shell> <username>


# Load .zsh_private if it exists
if [[ -f ~/.zsh_private ]]; then
  source ~/.zsh_private
fi

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


## APPEARANCE ----------

# Load colors
autoload -U colors 
colors

# Customize command prompt
autoload -Uz vcs_info
setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats "%{$fg_bold[green]%}%s %r %{$fg_no_bold[green]%}[%b] %{$fg_bold[magenta]%}%m%u%c%{$reset_color%} "
# zstyle ':vcs_info:git:*' actionformats ' [%b|%s|%a]'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' untrackedstr '%'

precmd_functions+=('vcs_info_pre')
function vcs_info_pre() {
  vcs_info
  PS1="
%{$fg[white]%}@%m (%*) %{$fg_bold[yellow]%}%1~/%{$reset_color%} \${vcs_info_msg_0_}%{$reset_color%}
> "
}



## KEYBINDINGS ---------

bindkey "^[[1~" beginning-of-line # HOME 
bindkey "^[[4~" end-of-line # END
bindkey "\e[3~" delete-char # DEL

bindkey "^[h" backward-kill-word # M-h

bindkey "^[n" down-line-or-history
bindkey "^[p" up-line-or-history


# VARIABLES -----------------------

# Set PATH
PATH="$PATH:/usr/bin/vendor_perl:/home/makmiller/scripts/myscripts:$HOME/.local/bin:/opt/cuda/bin"
export PATH

# CUDA vars
export NVCC_PREPEND_FLAGS='-ccbin /opt/cuda/bin'
export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH
export CUDA_VISIBLE_DEVICES=0

# Set default editor for zsh
# EDITOR is for programs that expect a line editor. VISUAL is for
# screen-oriented programs.
export EDITOR=/usr/bin/vim
export VISUAL=/home/makmiller/scripts/myscripts/edit.sh
export ALTERNATE_EDITOR=nvim


# CDPATH
# The nullstring "::" forces cd to search in the working directory
# This is important because, without it, cd will only search the working
# directory after the other directories in CDPATH fails. 
export CDPATH=::$HOME:$HOME/Documents/mydocs

# max size directory stack
DIRSTACKSIZE=12

#dirs `cat $HOME/.zsh_dir-stack` # permanent directory stack


# rehash automatically
zstyle ':completion:*' rehash true

# Words
# for zsh, not just alphanumerics are part of a word, but other
# symbols stated by the shell variable WORDCHARS. By making this
# variable empty, I get the bash behavior. default value
# WORDCHARS=*?_-.[]~=/&;!#$%^(){}<>
export WORDCHARS="?[]~=&;!#$%^(){}<>"
# I removed the symbols: *./-_



# history related
HISTSIZE=2000
SAVEHIST=2000
HISTFILE=~/.zsh_history
export SAVEHIST=$HISTSIZE # save history

# mail
# export MAILCHECK=120 # how often (in seconds) shell checks for new email
# export MAILPATH=/home/makmiller/Mail/default/cur # pathname of the file that holds your mail 
# 
#export MAIL # in the case of the variable mail 

## OPTIONS --------------
setopt NO_BEEP	      # disable beeping
setopt ignore_eof     # exit only if I press C-d ten times in a row
setopt auto_cd        # change directory by typing a directory name 
setopt extended_glob  # turn on the more powerful pattern matching features
# With this option, the characters ^, ~, and # become special wherever they appear unquoted
setopt correctall     # enable correction commands typed
setopt NOTIFY	      # notify when jobs finish
setopt nohup
setopt share_history 		# share history between shell instances

# -- directory stack options
setopt autopushd		# make cd always behave like pushd
setopt pushd_ignore_dups	# disable multiple copies of the same
				# directory on the directory stack
setopt pushd_silent   # don't print the directory stack after pushd or
		      # popd


# history related
setopt hist_ignore_all_dups 
setopt hist_ignore_space

# COMPLETION ----

# compinit
autoload -U compinit
compinit

# fzf
# Enable fzf if it is installed
if command -v fzf >/dev/null 2>&1; then
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
    # bindkey '' fzf-file-widget
    # bindkey '' fzf-cd-widget
fi

# predict
# autoload predict-on
# predict-on

# syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# THINGS TO DO 
# use directory-stack with tab completion
# save my directory-stack (persistent directory stack)

# autocompletion for aliases
# setopt COMPLETE_ALIASES

# zstyle

# enable caching (for speed)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# general completion
zstyle ':completion:*' menu select # activate menu selection
zstyle ':completion:*' verbose yes # print descriptions against each match
zstyle ':completion:*' group-name '' # separate matches in distinct related groups

# use internal pager to display matches
zmodload zsh/complist		 
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
bindkey -M listscroll q send-break # q exits internal pager

# fuzzy matching 
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

zstyle -e ':completion:*:approximate:*' \
    max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)' 
# The number of errors allowed by approximate increase with the length
# of what you have typed so far


# format messages in bold prefixed with ---- 
zstyle ':completion:*' format '%B---- %d%b' 
zstyle ':completion:*:descriptions' format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}' 
zstyle ':completion:*:messages' format '%B%U---- %d%u%b' 
zstyle ':completion:*:warnings' format "%B$fg[red]%}---- no match for: $fg[white]%d%b"  

# process completion
zstyle ':completion:*:*:*:*:processes' insert-ids menu yes select 
# when completing process IDs fall into menu selection

zstyle ':completion:*:*:*:*:processes' force-list always
# always display the list (even if there is only one possible completion)

# process name completion
zstyle ':completion:*:processes' command 'ps c -u ${USER} -o pid,%cpu,cputime,cmd' 
# alternative completions: tty #'ps -U $(whoami) | sed "/ps/d"'

# kill
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# complete manpages by section
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.*' insert-sections true

# colors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# cd will never select the parent directory (e.g.: cd../<TAB>)
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# helper functions
okular() { command okular ${*:-*.pdf(om[1])} }
zstyle ':completion:*:*:okular:*' menu yes select
zstyle ':completion:*:*:okular:*' file-sort time

# completing on the prefix
# (i.e., complete in the middle of some text ignoring the suffix)
bindkey '^i' expand-or-complete-prefix # binding TAB

# CUSTOM FUNCTIONS ----------------

# # do ls right after cd
# cd () {
#   if [ -n $1 ]; then
#     builtin cd "$@" && ls
#   else
#     builtin cd ~ && ls
#   fi
# }


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

