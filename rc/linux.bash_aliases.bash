
# shellcheck disable=SC2139,2016,2034,1087,2154,SC1090

case "$TERM" in
	xterm|putty|screen|tmux)
		TERM="${TERM}-256color"
		;;
esac

if [ -f "$HOME/.local_creds" ]; then
	# shellcheck disable=1091
	. "$HOME/.local_creds"
fi

# export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugins"

if [[ $(uname) == CYGWIN* ]]; then
	PATH=${PATH//\:\/cygdrive\/c\/MinGW\/bin/}
	PATH=${PATH//\:\/cygdrive\/c\/MinGW\/msys\/1.0\/bin/}
fi

if [ -n "$BASH_VERSION" ]; then
	bind '"\C-p": shell-kill-word'
	bind '"\C-b": shell-backward-word'
	bind '"\C-f": shell-forward-word'
	bind '"\C-h": forward-search-history'

	alias g='git'
	alias gcp='git cherry-pick'
	alias gmtvim='git mergetool --no-prompt --tool=vimdiff'

	if [ -n "$TMUX" ]; then
		stty -ixon
		bind '"\C-s": shell-backward-word'
	fi
elif [ -n "$ZSH_VERSION" ]; then
	unalias md 2>/dev/null

	#unset LESS
	#PROMPT='%{$fg_bold[cyan]%}%~%{$reset_color%} '
	PROMPT=''
	#if [[ $(uname) != CYGWIN* ]]; then
	#        PROMPT+='$(git_prompt_info)'
	#        ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
	#fi
	#PROMPT+='${ret_status}%{$reset_color%}'
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
alias ssh-copy-id-root='ssh-copy-id -i /root/.ssh/id_rsa.pub'
alias hw.c='echo -e "#include <stdio.h>\n\nint main(void)\n{\n\n	printf(\"Hello, world\\\n\");\n\n	return 0;\n\n}\n" > hw.c'
alias sedxml='sed "s/></>\n</g"'
alias rs='rsync -a --info=progress2'
alias personal-init='personal_init'
alias tmux='tmux -2'
alias docker-lsi='docker image ls --format="{{.Repository}}:{{.Tag}}"'
alias gg='git grep -Ovi'

alias k='kubectl'
alias ka='k apply -f'
alias kd='k delete -f'
alias kg='k get'

alias t='tig --first-parent'
