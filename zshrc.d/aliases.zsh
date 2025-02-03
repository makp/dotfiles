## ALIASES ---------

# Default applications
alias o="xdg-open"

# Wrapper to change cwd when exiting yazi with `q`
# Press `Q` to exit yazi without changing the cwd
# Source: https://yazi-rs.github.io/docs/quick-start
function oh() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# ls
if command -v eza >/dev/null 2>&1; then
  alias ll="eza --color=always --all --long --git --no-user"
  alias ls="eza --color=always --all --long --git --no-user --no-permissions --no-filesize --icons=always --no-time"
fi

#
# Assistants
#

# Assistants - General
alias a="aichat --model openai:${OPENAI_BASIC} "
alias aa="aichat --model openai:${OPENAI_ADVANCED} "
alias aA="aichat --model anthropic:${ANTHROPIC_MODEL} "

# Assistant - reasoning
alias ar="assistant_reasoning.py -m "
alias aR="assistant_reasoning.py "

# Assistant - online search
alias ao="assistant_online-search.py "

# Assistants - coding (copilot)
# You need to install the copilot extension for gh:
# https://docs.github.com/en/copilot/managing-copilot/configure-personal-settings/installing-github-copilot-in-the-cli
# eval "$(gh copilot alias -- zsh)" # For some reason, this was slow
alias ace="gh copilot explain "
alias acr="gh copilot suggest "

# Editor
alias e="nvim "
alias eh="nvim ."
alias eu="run_fzf-on-files-and-dirs.sh"
alias ea="run_rg.sh"
alias er="nvim +'FzfLua oldfiles cwd_only=true'"

# Git
alias gt="lazygit"

alias cg="cd \$(git rev-parse --show-toplevel)"  # cd to root git repo

alias gs="git status --short -b"
alias gS="check-git-repos-status-recursive.sh"

alias gss="git submodule foreach 'git status --short'"
alias gsa="git submodule add "
alias gsi="git submodule update --init --recursive" # commit specified by the parent repo
alias gsu="git submodule update --remote --recursive" # latest commit

alias gf="git fetch --all"

alias gp="git pull"
alias gps="git pull --recurse-submodules"
alias gpr="git pull --rebase"

alias gb="git branch --all"
alias gbn="git checkout -b "
alias gbd="git branch -D "
alias gbD="git push origin --delete "

alias ga="git add"
alias gac="git commit -a "

alias gc="git commit "
alias gca="git commit --amend --no-edit"
alias gcA="git commit --amend"

alias gd="git diff --submodule"
alias gds="git diff --staged --submodule"

alias gl="git log -p --submodule"
alias glo="git graph origin..HEAD"

function git_clean_confirm() {
 git clean -fd --dry-run
 echo
 read "REPLY?Proceed with git clean -fd? (y/n): "
 if [[ $REPLY =~ ^[Yy]$ ]]; then
   git clean -fd
 else
   echo "git clean -fd aborted."
 fi
}
alias gC="git_clean_confirm"

alias gr="git reset "
alias grh="git reset HEAD" # unstage changes in the staging area
alias grH="git reset --hard HEAD" # reset repo to the last commit


# Linux pkg manager
alias pu="sudo pacman -Syu"
alias pU="yay -Sua --devel"
alias pl="pacman -Q | grep -i " # Search for a pkg
alias pL="pacman -Qm" # List foreign packages
alias pc="yay -Sc"
alias pf="yay -Ql" # List files in a package
alias po='yay -Qo' # Which pkg owns a file
alias pi='yay -Qi' # Info about a pkg

# Python pkg manager



# Convert between file formats
alias cmh="convert_md_to_html.py"
alias cms="pandoc -i -t revealjs -s "
alias cmn="jupytext --to notebook "
alias com="pandoc -t gfm -f org "
alias cpt="pdftotext "

# Linux logs
# https://wiki.archlinux.org/title/Systemd/Journal#Filtering_output
# The `x` flag shows explanations of log fields
alias lb="journalctl -xb -0" # Show logs since last boot
alias lB="journalctl --list-boots" # List boots
alias lc="journalctl -p err..alert -b 0 -x" # Show logs with priority error, critical, and alert
alias lu="journalctl -ux " # Show logs for a specific unit
alias la="journalctl --grep=" # Search log matching a pattern
alias lk="journalctl -xk" # Show kernel logs
