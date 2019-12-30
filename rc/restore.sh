#!/bin/bash
trap 'echo "$0: Error at $LINENO"; exit 1;' ERR

hash curl
hash git

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

	zsh_completions=${ZSH_CUSTOM:-"$HOME/.oh-my-zsh/custom"}/plugins/zsh-completions
	if [ ! -d "$zsh_completions" ]; then
		git clone https://github.com/zsh-users/zsh-completions "$zsh_completions"
		sed -i.bu 's/plugins=(/&zsh-completions /' ~/.zshrc
		if ! grep -q -F 'autoload -U compinit && compinit' ~/.zshrc; then
			echo 'autoload -U compinit && compinit' >> ~/.zshrc
		fi
		rm -f ~/.zcompdump
		rm -f ~/.zshrc.bu
	fi
fi

cd "$(dirname "$0")"

for f in linux.{vimrc,gitconfig,ctags} linux.bash_{aliases,functions}.bash linux.tmux.conf; do
	ln -f -s "$PWD/$f" "$HOME/${f#linux}"
done

if [ -d "$ZSH" ] && [ -e "$HOME/.zshrc" ]; then
	with_sh='zsh'
elif [ -n "$BASH_VERSION" ]; then
	with_sh='bash'
else
	echo >&2 "Unsupported shell: $SHELL"
	exit 1
fi

rc="$HOME/.${with_sh}rc"

if ! grep -Fq .bash_aliases.bash "$rc" || ! grep -Fq .bash_functions.bash "$rc"; then
	cat >> "$rc" <<-'EOF'

	if [ -e ~/.bash_aliases.bash ]; then
		. ~/.bash_aliases.bash
	fi

	if [ -e ~/.bash_functions.bash ]; then
		. ~/.bash_functions.bash
	fi

	PATH="$HOME/git/personal/linux_shell_scripts:$HOME/bin:\$PATH"

	EOF
fi

vim_plug='https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
tmux_plug='https://github.com/tmux-plugins/tpm'

if hash nvim 2>/dev/null; then
	plug_file="$HOME/.local/share/nvim/site/autoload/plug.vim"
	mkdir -p "$HOME/.config/nvim/"
	if [ ! -e "$HOME/.config/nvim/init.vim" ]; then
		ln -s "$HOME/.vimrc" "$HOME/.config/nvim/init.vim"
	fi
	if [ ! -e "$HOME/.config/nvim/coc-settings.json" ]; then
		ln -s "$PWD/coc-settings.json" "$HOME/.config/nvim/coc-settings.json"
	fi
else
	hash vim
	plug_file="$HOME/.vim/autoload/plug.vim"
fi

if hash tmux 2>/dev/null; then
	if [ ! -d ~/.tmux/plugins/tpm ]; then
		git clone "$tmux_plug" ~/.tmux/plugins/tpm
	fi
fi

if [ ! -e "$plug_file" ]; then
	curl -fLo "$plug_file" --create-dirs "$vim_plug"
fi

if uname | grep -q CYGWIN; then
if ! grep -q x11_toggle "$rc"; then
cat >> "$rc" <<'EOF'

x11_toggle ()
{
	if ps aux | grep -q XWin; then
		echo -n 'Stop X server? '
		read -r
		kill -- -$(ps aux | awk '/[x]init/{print $2}')
		while ps aux | grep -q XWin; do
			sleep 1
		done
		pstree
		unset DISPLAY
		export DISPLAY
	else
		echo -n 'Start X server? '
		read -r
		startxwin -- -multiwindow -listen tcp >/dev/null 2>&1 &
		while ! ps aux | grep -q XWin; do
			sleep 1
		done
		pstree
		export DISPLAY='localhost:0.0'
	fi
}

EOF
fi

if [ -f "/cygdrive/c/Users/$(whoami)/Documents/WindowsPowerShell/profile.ps1" ]; then
	cp profile.ps1 "/cygdrive/c/Users/$(whoami)/Documents/WindowsPowerShell/profile.ps1"
fi
fi

if [ -d "$HOME/.jira.d/" ]; then
	ln -s "$PWD/jira.config.yml" "$HOME/.jira.d/config.yml"
fi

if [ ! -e "$HOME/git" ]; then
	mkdir "$HOME/git"
fi

if [ -d "$HOME/git" ]; then
	cd "$HOME/git"

	if [ ! -d "$HOME/git/diff-so-fancy" ]; then
		git clone "https://github.com/so-fancy/diff-so-fancy"
	fi

	if ! grep -Fq '$HOME/git/diff-so-fancy' "$rc"; then
		echo 'PATH="$HOME/git/diff-so-fancy:\$PATH"' >> "$rc"
	fi
fi

