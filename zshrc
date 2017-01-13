# -*-conf-*-
# source ~/.zshrc
# In order to change the default shell, use: usermod -s /bin/<shell> <username>

# load the function-based completion system
autoload -U compinit
compinit

# load colors
autoload -U colors 
colors

## KEYBINDINGS ---------

bindkey "^[[1~" beginning-of-line # HOME 
bindkey "^[[4~" end-of-line # END
bindkey "\e[3~" delete-char # DEL

bindkey "^[h" backward-kill-word # M-h

bindkey "^[n" down-line-or-history
bindkey "^[t" up-line-or-history

# VARIABLES -----------------------

# path
PATH="$PATH:/home/makmiller/scripts/myscripts:/home/makmiller/scripts/third-party-scripts"
export PATH

# editor
export EDITOR=/home/makmiller/scripts/myscripts/edit.sh
export VISUAL=/home/makmiller/scripts/myscripts/edit.sh
export ALTERNATE_EDITOR=emacs

# CDPATH
# The nullstring "::" forces cd to search in the working directory
# This is important because, without it, cd will only search the working
# directory after the other directories in CDPATH fails. 
export CDPATH=::$HOME:$HOME/Documents/pdfs

# max size directory stack
DIRSTACKSIZE=12

#dirs `cat $HOME/.zsh_dir-stack` # permanent directory stack

# words
# for zsh, not just alphanumerics are part of a word, but other symbols stated by the shell variable WORDCHARS. By making this variable empty, I get the bash behavior. 
# default value
# WORDCHARS=*?_-.[]~=/&;!#$%^(){}<>
export WORDCHARS="?[]~=&;!#$%^(){}<>"
# I removed the symbols: *./-_



# my prompt
## PS1 (primary)
export PS1="%{$fg[green]%}%1c> %{$reset_color%}"

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

# #  ------
# #  ZSTYLE
# #  ------

# THINGS TO DO 
# use directory-stack with tab completion
# save my directory-stack (persistent directory stack)


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

# REGULAR ALIASES ----------------

# locate
alias atualize="updatedb -v -l 0 -o /home/makmiller/elisp/locate.db -U /home/makmiller/Documents/pdfs/"

# emacs related alias
alias em='emacsclient -t'
alias emcs='emacsclient -c'
alias Fecha-emacs='emacsclient -e "(kill-emacs)"' # doesn't prompt for saving files
alias fecha-emacs='emacsclient -e "(client-save-kill-emacs)"' # 

alias imprima-office='lp -d HP_Officejet_Pro_8100 -o sides=two-sided-long-edge'

# email related
#alias check-email='fetchmail -vk'

#
# alias weather_cal='weather --id=CYYC'

alias alarme='icsy -n 0'

# ls related
alias ls='ls -F --color'
alias ll='ls -lh'

# directory stack
# alias pu=pushd I don't need this any more since I'm using the autopush option
alias dirs='dirs -v'
#alias ds='pwd >> $HOME/.zsh_dir-stack'

# power related
alias devagar='sudo cpufreq-set -g powersave; sudo cpufreq-set -c 1 -g powersave'
alias rapido='sudo cpufreq-set -g ondemand; sudo cpufreq-set -c 1 -g ondemand'
alias super_rapido='sudo cpufreq-set -g performance; sudo cpufreq-set -c 1 -g performance'
# alias shutdown='sudo shutdown -h now'

# tar related
alias tarbz2='tar cjvf' #tar cjvf archive.tar.bz2 reports

# alias for my scripts
alias sincro='/home/makmiller/myscripts/sincro.sh'

# alias for byte-compile with Emacs
alias compila='emacs -batch -f batch-byte-compile thefile.el'

# SPECIAL ALIASES ---------------------

# suffix aliases
alias -s pdf=okular
alias -s djvu=okular
#djview4
alias -s chm=kchmviewer


## music
# alias -s mp3='mplayer -slave -input file=/home/makmiller/mplayer.pipe -loop 0'

## video
alias -s mp4='mplayer -loop 0'

# global aliases
alias -g less='less -R' # less with colors

# CUSTOM FUNCTIONS ----------------


# extract

# do ls right after cd
cd () {
  if [ -n $1 ]; then
    builtin cd "$@" && ls
  else
    builtin cd ~ && ls
  fi
}

# renaming files
# ren(){
# for f in *
# do 
#     echo "renaming ${f} to
