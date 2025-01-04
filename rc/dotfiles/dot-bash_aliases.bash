# shellcheck disable=2016,2034

if [ -f "$HOME/.local_creds" ]; then
	# shellcheck disable=1091
	. "$HOME/.local_creds"
fi

# export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugins"

if [ -n "$ZSH_VERSION" ]; then
	unalias md 2>/dev/null

	PROMPT=''
	PROMPT+='%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )%{$reset_color%}'

	WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

	bindkey "^[[1~" beginning-of-line
	bindkey "^[[4~" end-of-line

	bindkey '^p' kill-word
	bindkey '^b' backward-word
	bindkey '^f' forward-word
	bindkey '^h' history-incremental-search-forward
	bindkey '^u' backward-kill-line
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

#alias sudo='sudo_wrapper'
alias cd..='cd ..'
alias sl='ls'
#alias less='less -i -R -N'
export LESS='-i -R'
alias diff='colordiff'
alias docker-lsi='docker image ls --format="{{.Repository}}:{{.Tag}}"'
alias gg='git grep -Ovi'

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
