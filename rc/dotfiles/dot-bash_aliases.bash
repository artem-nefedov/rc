# shellcheck disable=2016,2034

if [ -f "$HOME/.local_creds" ]; then
	# shellcheck disable=1091
	. "$HOME/.local_creds"
fi

# export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugins"

if [ -n "$ZSH_VERSION" ]; then
	unalias md 2>/dev/null

	PROMPT='%B%(?:%F{green}:%F{red})➜ %f%b'

	WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

	bindkey "^[[1~" beginning-of-line
	bindkey "^[[4~" end-of-line

	# omz binds:
	# "^@" set-mark-command
	# "^A" beginning-of-line
	# "^B" backward-word
	# "^D" delete-char-or-list
	# "^E" end-of-line
	# "^F" forward-word
	# "^G" send-break
	# "^H" history-incremental-search-forward
	# "^I" fzf-completion
	# "^J" accept-line
	# "^K" kill-line
	# "^L" clear-screen
	# "^M" accept-line
	# "^N" down-line-or-history
	# "^O" accept-line-and-down-history
	# "^P" kill-word
	# "^Q" push-line
	# "^R" fzf-history-widget
	# "^S" history-incremental-search-forward
	# "^T" fzf-file-widget
	# "^U" backward-kill-line
	# "^V" quoted-insert
	# "^W" backward-kill-word
	# "^X^B" vi-match-bracket
	# "^X^E" edit-command-line
	# "^X^F" vi-find-next-char
	# "^X^J" vi-join
	# "^X^K" kill-buffer
	# "^X^N" infer-next-history
	# "^X^O" overwrite-mode
	# "^X^U" undo
	# "^X^V" vi-cmd-mode
	# "^X^X" exchange-point-and-mark
	# "^X*" expand-word
	# "^X=" what-cursor-position
	# "^XG" list-expand
	# "^Xg" list-expand
	# "^Xr" history-incremental-search-backward
	# "^Xs" history-incremental-search-forward
	# "^Xu" undo
	# "^Y" yank
	# "^[^D" list-choices
	# "^[^G" send-break
	# "^[^H" backward-kill-word
	# "^[^I" self-insert-unmeta
	# "^[^J" self-insert-unmeta
	# "^[^L" clear-screen
	# "^[^M" self-insert-unmeta
	# "^[^_" copy-prev-word
	# "^[ " expand-history
	# "^[!" expand-history
	# "^[\"" quote-region
	# "^[\$" spell-word
	# "^['" quote-line
	# "^[-" neg-argument
	# "^[." insert-last-word
	# "^[0" digit-argument
	# "^[1" digit-argument
	# "^[2" digit-argument
	# "^[3" digit-argument
	# "^[4" digit-argument
	# "^[5" digit-argument
	# "^[6" digit-argument
	# "^[7" digit-argument
	# "^[8" digit-argument
	# "^[9" digit-argument
	# "^[<" beginning-of-buffer-or-history
	# "^[>" end-of-buffer-or-history
	# "^[?" which-command
	# "^[A" accept-and-hold
	# "^[B" backward-word
	# "^[C" capitalize-word
	# "^[D" kill-word
	# "^[F" forward-word
	# "^[G" get-line
	# "^[H" run-help
	# "^[L" down-case-word
	# "^[N" history-search-forward
	# "^[OA" up-line-or-beginning-search
	# "^[OB" down-line-or-beginning-search
	# "^[OC" forward-char
	# "^[OD" backward-char
	# "^[OF" end-of-line
	# "^[OH" beginning-of-line
	# "^[P" history-search-backward
	# "^[Q" push-line
	# "^[S" spell-word
	# "^[T" transpose-words
	# "^[U" up-case-word
	# "^[W" copy-region-as-kill
	# "^[[1;5C" forward-word
	# "^[[1;5D" backward-word
	# "^[[1~" beginning-of-line
	# "^[[200~" bracketed-paste
	# "^[[3;5~" kill-word
	# "^[[3~" delete-char
	# "^[[4~" end-of-line
	# "^[[5~" up-line-or-history
	# "^[[6~" down-line-or-history
	# "^[[A" up-line-or-beginning-search
	# "^[[B" down-line-or-beginning-search
	# "^[[C" forward-char
	# "^[[D" backward-char
	# "^[[Z" reverse-menu-complete
	# "^[_" insert-last-word
	# "^[a" accept-and-hold
	# "^[b" backward-word
	# "^[c" fzf-cd-widget
	# "^[d" kill-word
	# "^[f" forward-word
	# "^[g" get-line
	# "^[h" run-help
	# "^[l" "ls^J"
	# "^[m" copy-prev-shell-word
	# "^[n" history-search-forward
	# "^[p" history-search-backward
	# "^[q" push-line
	# "^[s" spell-word
	# "^[t" transpose-words
	# "^[u" up-case-word
	# "^[w" kill-region
	# "^[x" execute-named-cmd
	# "^[y" yank-pop
	# "^[z" execute-last-named-cmd
	# "^[|" vi-goto-column
	# "^[^?" backward-kill-word
	# "^_" undo
	# " " magic-space
	# "!"-"~" self-insert
	# "^?" backward-delete-char
	# "\M-^@"-"\M-^?" self-insert

	bindkey '^p' kill-word
	bindkey '^b' backward-word
	bindkey '^f' forward-word
	bindkey '^w' backward-kill-word
	bindkey '^h' history-incremental-search-forward
	bindkey '^u' backward-kill-line
	bindkey '^a' beginning-of-line
	bindkey '^e' end-of-line
	bindkey '^k' kill-line
	bindkey '^y' yank
	bindkey '^_' undo
	if [ -n "$TMUX" ]; then
		bindkey '^s' backward-word
	fi
fi

if [ "$(uname)" != Darwin ]; then
	if hash nvim 2>/dev/null; then
		alias nvim='TERM=screen-256color nvim'
	else
		alias nvim='TERM=screen-256color vim'
	fi
fi

alias cdp='cd $HOME/git/personal'
alias cdP=cdp
alias cdg='cd ~/git'
alias cdd='cd ~/Downloads'
alias cdD='cd ~/Desktop'
alias cd..='cd ..'

alias -- -='cd -'
alias ...=../..
alias ....=../../..
alias .....=../../../..
alias ......=../../../../..
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls -G'
alias lsa='ls -lah'
alias sl='ls'

#alias sudo='sudo_wrapper'
#alias less='less -i -R -N'
export LESS='-i -R'
alias diff='colordiff'
alias docker-lsi='docker image ls --format="{{.Repository}}:{{.Tag}}"'

alias g='git'
alias gcp='git cherry-pick'
alias gl='git pull'
alias gg='git grep -Ovi'
alias gs='git status'

alias k='kubectl'
alias ka='k apply -f'
alias kd='k delete -f'
alias kg='k get'

alias t='tig --first-parent'

alias :e=v

alias :h='call_vim_cmd help'
alias :help='call_vim_cmd help'
alias :man='call_vim_cmd Man'
alias :Man='call_vim_cmd Man'
