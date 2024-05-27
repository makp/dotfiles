#!/usr/bin/env bash

# Grep with ripgrep and fzf
# From <https://github.com/junegunn/fzf/blob/master/ADVANCED.md#ripgrep-integration>
#
# Ripgrep is used to search for files, and fzf is used as a fuzzy filter for
# the results. `bat` is used to preview the matched line.
# Switch between Ripgrep mode and fzf filtering mode (CTRL-T)
rm -f /tmp/rg-fzf-{r,f}
RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
INITIAL_QUERY="${*:-}"
: | fzf --ansi --disabled --query "$INITIAL_QUERY" \
	--bind "start:reload:$RG_PREFIX {q}" \
	--bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
	--bind 'ctrl-t:transform:[[ ! $FZF_PROMPT =~ ripgrep ]] &&
      echo "rebind(change)+change-prompt(1. ripgrep> )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r" ||
      echo "unbind(change)+change-prompt(2. fzf> )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"' \
	--color "hl:-1:underline,hl+:-1:underline:reverse" \
	--prompt '1. ripgrep> ' \
	--delimiter : \
	--header 'CTRL-T: Switch between ripgrep/fzf' \
	--preview 'bat --color=always {1} --highlight-line {2}' \
	--preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
	--bind 'enter:become(nvim {1} +{2})'
