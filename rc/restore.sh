#!/bin/bash

set -e
trap 'echo >&2 "$0: Error at $LINENO: $BASH_COMMAND"' ERR

script_dir=$(cd "$(dirname "$0")" && pwd)

hash curl
hash git
hash stow

if [ "$1" = '-z' ]; then
	if [ -z "$ZSH" ]; then
		reply_pattern='^[yY]|[yY][eE][sS]$'

		echo -n 'Install oh-my-zsh? [Y/n] '
		read -r reply
		if [ -z "$reply" ] || [[ "$reply" =~ $reply_pattern ]]; then
			sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
		fi

		if uname | grep -q CYGWIN && grep -q 'db_shell: /bin/bash' /etc/nsswitch.conf; then
			echo -n 'Change default shell to zsh? [Y/n] '
			read -r reply
			if [ -z "$reply" ] || [[ "$reply" =~ $reply_pattern ]]; then
				sed -i 's,# db_shell: /bin/bash,db_shell: /usr/bin/zsh,' /etc/nsswitch.conf
			fi
		fi
	fi

	zsh_completions=${ZSH_CUSTOM:-${ZSH:-$HOME/.oh-my-zsh}/custom}/plugins/zsh-completions
	if [ ! -d "$zsh_completions" ]; then
		git clone https://github.com/zsh-users/zsh-completions "$zsh_completions"
		rm -f ~/.zcompdump
	fi
fi

cd "$(dirname "$0")"

mkdir -p "$HOME/.config"
stow --dotfiles -t "$HOME" dotfiles

if [ -d "$HOME/.jira.d/" ]; then
	ln -s "$script_dir/jira.config.yml" "$HOME/.jira.d/config.yml"
fi

if [ ! -e "$HOME/git" ]; then
	mkdir "$HOME/git"
fi

if [ -d "$HOME/git" ]; then
	cd "$HOME/git"

	if [ ! -d "$HOME/git/diff-so-fancy" ]; then
		git clone "https://github.com/so-fancy/diff-so-fancy"
	fi
fi
