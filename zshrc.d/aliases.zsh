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
alias a="sgpt --model '${OPENAI_BASIC}' --temperature 0.3 "
alias aA="aichat --model anthropic:${ANTHROPIC_MODEL} "
alias aa="sgpt --model '${OPENAI_ADVANCED}' --temperature 1 "

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
alias ef="run_fzf-on-files-and-dirs.sh"
alias eg="run_rg.sh"

# Git
alias gg="lazygit"

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
alias pL="pacman -Qm" # List foreign packages
alias pc="yay -Sc"
alias pf="yay -Ql" # List files in a package

# Python pkg manager
alias pyl="conda env export | bat -l yml"
alias pyh="conda env export --from-history | bat -l yml"
alias pyH="conda env export --from-history > environment.yml"
alias pyC="clone-and-update-conda-env.sh "


# Convert between file formats
alias cmh="convert_md_to_html.py"
alias cms="pandoc -i -t revealjs -s "
alias com="pandoc -t gfm -f org "
alias cmn="jupytext --to notebook "
