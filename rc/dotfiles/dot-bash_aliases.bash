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

	# home/end/delete
	bindkey "^[[H" beginning-of-line
	bindkey "^[[F" end-of-line
	bindkey "^[[3~" delete-char

	autoload -U up-line-or-beginning-search
	autoload -U down-line-or-beginning-search
	zle -N up-line-or-beginning-search
	zle -N down-line-or-beginning-search
	bindkey "^[[A" up-line-or-beginning-search
	bindkey "^[[B" down-line-or-beginning-search
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
alias cd-='cd -'

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
alias :mes='call_vim_cmd mes'
