# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load prompt theme
zinit light /usr/share/zsh-theme-powerlevel10k/

# Source Powerlevel10k if file exists
# Run `p10k configure` to customize prompt
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
