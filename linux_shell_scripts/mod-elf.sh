#!/bin/bash

trap 'echo >&2 "$0: Error at $LINENO: $BASH_COMMAND"; exit 1;' ERR

if [ -z "$2" ]; then
	echo >&2 "Usage: ${0##*/} old_path new_path"
	exit 1
fi

if [ ! "$(echo -n "$1" | wc -c)" = "$(echo -n "$2" | wc -c)" ]; then
	echo >&2 "Paths must be of equal size"
	exit 1
fi

if [ "$1" = "$2" ]; then
	echo >&2 "Paths are identical"
	exit 1
fi

to_hex() { xxd -p "$@" | tr -d '\n'; }

orig_hex="$(echo -n "$1" | to_hex -)"
mod_hex="$(echo -n "$2" | to_hex -)"

echo "With orig_hex=[$orig_hex]"
echo "With  mod_hex=[$mod_hex]"

while read -r f; do
	if ldd "$f" | grep -q "$1"; then
		echo " == EDITING [$f]"
		to_hex "$f" | sed "s/$orig_hex/$mod_hex/g" | xxd -p -r > "$f.mod.$$"
		#echo "export LD_LIBRARY_PATH=$mod_path/SAMSUNG/IVI/sysroots/x86_64-pokysdk-linux/lib
		#\"\${0}_BIN\" \"\$@\"" > "$f"
		#mv -n "$f.mod.$$" "${f}_BIN"
		mv "$f.mod.$$" "${f}"
		#chmod a+x "$f" "${f}_BIN"
		chmod a+x "$f"
	fi
done < <(find . -type f)

