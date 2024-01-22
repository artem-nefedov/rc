#!/bin/bash

set -e
trap 'echo >&2 "$0: Error at $LINENO: $BASH_COMMAND"' ERR

script_dir=$(cd "$(dirname "$0")" && pwd)

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

for f in linux.{gitconfig,ctags} linux.bash_{aliases,functions}.bash linux.tmux.conf; do
	ln -f -s "$script_dir/$f" "$HOME/${f#linux}"
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

	PATH="$HOME/git/personal/linux_shell_scripts:$HOME/bin:$PATH"

	EOF
fi

nvimdir="$HOME/.config/nvim"
mkdir -p "$nvimdir"
(
	cd "$script_dir/nvim-lua/" &&
	for f in "$PWD"/*; do
		if [ ! -e "$nvimdir/${f##*/}" ]; then
			ln -s "$f" "$nvimdir/${f##*/}" || exit 1
		fi
	done
)

tmux_plug='https://github.com/tmux-plugins/tpm'

if hash tmux 2>/dev/null; then
	if [ ! -d ~/.tmux/plugins/tpm ]; then
		git clone "$tmux_plug" ~/.tmux/plugins/tpm
	fi
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

	# shellcheck disable=2016
	if ! grep -Fq '$HOME/git/diff-so-fancy' "$rc"; then
		echo 'PATH="$HOME/git/diff-so-fancy:$PATH"' >> "$rc"
	fi
fi

git_comp='/usr/local/share/zsh/site-functions/git-completion.bash'

if [ -f "$git_comp" ] && ! grep -q '^_git_sw ' "$git_comp"; then
	#sed -i.bu 's/-d|--delete|-m|--move)/-D|&/' "$git_comp"
	# shellcheck disable=2016
	echo '_git_sw () { __gitcomp_direct "$(__git_heads "" "$track" " ")"; }' >> "$git_comp"
fi

mkdir -p "$HOME"/.config/alacritty
ln -sf "$script_dir"/alacritty.toml "$HOME"/.config/alacritty/alacritty.toml

if ! grep -qx '# RC AUTOJUMP' "$rc"; then
cat >> "$rc" <<'EOF'

# RC AUTOJUMP
if [ -f /opt/homebrew/etc/profile.d/autojump.sh ]; then
  . /opt/homebrew/etc/profile.d/autojump.sh
fi
EOF
fi

if ! grep -qx '# RC ASDF' "$rc"; then
cat >> "$rc" <<'EOF'

# RC ASDF
. /opt/homebrew/opt/asdf/libexec/asdf.sh
EOF
fi

if [ "$with_sh" = zsh ] && ! grep -qx '# OPTIMIZE PERFORMANCE' "$rc"; then
cat >> "$rc" <<'EOF'

# OPTIMIZE PERFORMANCE
add-zsh-hook -d precmd omz_termsupport_cwd
add-zsh-hook -d precmd omz_termsupport_precmd
add-zsh-hook -d preexec omz_termsupport_preexec
# export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
# _zsh_autosuggest_bind_widgets # run manually if needed
EOF
fi

if [ "$(uname)" = Darwin ]; then
	ln -s "$script_dir/Brewfile" "$HOME/.Brewfile"
fi
