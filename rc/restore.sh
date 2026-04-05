#!/bin/bash

set -e
trap 'echo >&2 "$0: Error at $LINENO: $BASH_COMMAND"' ERR

hash curl
hash git
hash stow

cd "$(dirname "$0")"

mkdir -p "$HOME/.config"
stow --dotfiles -t "$HOME" dotfiles

if [ ! -e "$HOME/git" ]; then
	mkdir "$HOME/git"
fi

if [ -d "$HOME/git" ]; then
	cd "$HOME/git"

	if [ ! -d "diff-so-fancy" ]; then
		git clone "https://github.com/so-fancy/diff-so-fancy"
	fi

	if [ ! -d "zsh-completions" ]; then
		git clone "https://github.com/zsh-users/zsh-completions.git"
	fi
fi

mkdir -p "$HOME/.cache/zsh-compcache"
rm -f "$HOME/.zcompdump" "$HOME/.cache/compdump"
