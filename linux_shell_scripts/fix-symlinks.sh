#!/bin/bash
# shellcheck disable=SC2164

trap 'echo "$0: Error at $LINENO: $BASH_COMMAND"; exit 1;' ERR

if [ -z "$1" ]; then
	echo "Usage: $0 dir1 dir2 ..."
	exit 1
fi

while read -r f; do
	if cmp -s <(head -c 10 "$f") <(echo -n '!<symlink>'); then
		echo "Fixing [$f]"
		link_path="$(tail -c +13 "$f")"
		rm -f "$f"
		cd "$(dirname "$f")"
		ln -s "$link_path" "$(basename "$f")"
		cd "$OLDPWD"
	fi
done < <(find "$@" -type f -size 1k)

