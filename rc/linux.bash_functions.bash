
convert_to_bytes()
{
	case "$1" in
		*[kK]|*[kK][bB])
			echo "$(( ${1%[kK]*} * 1024 ))";;
		*[mM]|*[mM][bB])
			echo "$(( ${1%[mM]*} * 1024 * 1024 ))";;
		*[gG]|*[gG][bB])
			echo "$(( ${1%[gG]*} * 1024 * 1024 * 1024 ))";;
		*)
			echo "${1%[bB]}";;
	esac
}


vba_escape()
{
	perl -0pe '
		s/"/""/g;
		s/\r//g; s/\n+$//;
		s/\n/" & vbCrLf & _\n"/g;
		s/^/"/; s/$/"\n/;
		'
		#s/(.{40})/$1" & _\n/g;
}

is_inside_git()
{
	if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = 'true' ]; then
		return 0
	else
		return 1
	fi
}

dirdiff ()
{
	local diff cG cN line type
	local find=( find \( \! -path '*/.git/*' -a \! -path '*/.svn/*' \) )

	case "$1" in
		rm|size|file|stat)
			type="$1"
			shift
			;;
		*)
			type='dir'
			;;
	esac

	if [ -z "$3" ] && hash colordiff 2>/dev/null; then
		diff=colordiff
		cG='\033[1;32m'
		cN='\033[0m'
	else
		diff='diff'
		cG=
		cN=
	fi

	if [ "$1" = '-s' ]; then
		( cd "${2:-.}" && touch dirdiff.list && "${find[@]}" | sort > dirdiff.list )
		echo "Created ${2:-.}/dirdiff.list"
	elif [ "$1" = '-l' ]; then
		echo -e "${cG}=== ${2:-.}/dirdiff.list vs ${2:-.} ===${cN}"
		( cd "${2:-.}" && $diff dirdiff.list <("${find[@]}" | sort) )
		if [ "$type" = 'rm' ]; then
			( cd "${2:-.}" && 'diff' dirdiff.list <("${find[@]}" | sort) | sed -n 's/^> //p' | while read -r line; do echo "rm -rf $line"; rm -rf "$line"; done )
		fi
	elif [ "$1" = '-d' ]; then
		echo "Removed ${2:-.}/dirdiff.list"
		( cd "${2:-.}" && rm -f dirdiff.list )
	elif [ -d "$1" ] && [ -d "$2" ]; then
		echo -e "${cG}=== $1 vs $2 ===${cN}"
		case "$type" in
			size)
				$diff   <(cd "$1" && "${find[@]}" -print0 | sort -z | xargs -0 stat -c $'%s\t%n') \
					<(cd "$2" && "${find[@]}" -print0 | sort -z | xargs -0 stat -c $'%s\t%n')
				;;
			file)
				$diff   <(cd "$1" && "${find[@]}" -print0 | sort -z | xargs -0 file) \
					<(cd "$2" && "${find[@]}" -print0 | sort -z | xargs -0 file)
				;;
			stat)
				$diff   <(cd "$1" && "${find[@]}" -print0 | sort -z | xargs -0 stat -c $'%A %h %U %G\t%n') \
					<(cd "$2" && "${find[@]}" -print0 | sort -z | xargs -0 stat -c $'%A %h %U %G\t%n')
				;;
			rm)
				( 'diff' <(cd "$1" && "${find[@]}" | sort) <(cd "$2" && "${find[@]}" | sort) | \
					sed -n 's/^> //p' | while read -r line; do echo "rm -rf $2/$line"; rm -rf "${2:?unset}/$line"; done )
				;;
			*)
				$diff <(cd "$1" && "${find[@]}" | sort) <(cd "$2" && "${find[@]}" | sort)
				;;
		esac
	else
		echo "Usage: dirdiff [rm|size|file|stat] <dir1> <dir2> [nocolor]"
		echo "Usage: dirdiff [rm] <-s|-l|-d> [dir] [nocolor]"
	fi
}

tonix ()
{
	if [ -z "$1" ]; then
		sed 's,\\,/,g'
	else
		echo "${@//\\//}"
	fi
}

sgrep ()
{
	[ -z "$1" ] && echo 'grep -ERI --exclude-dir=\\.svn --exclude-dir=\\.git "$@" [.|path]' && return 1
	local grepdir last
	eval last="\$$#"
	if [ ! -d "$last" ]; then
		grepdir='.'
	fi
	grep -ERI --exclude-dir=\\.svn --exclude-dir=\\.git "$@" ${grepdir:+"$grepdir"}
}

stylize ()
{
	if [ -z "$1" ]; then
		echo "Usage: stylize [-t] <file list>"
		return 0
	fi
	local dryrun cmd
	if [ "$1" = '-t' ]; then
		dryrun=1
		shift
	fi
	cmd='s/\]\s+\b(do|then)\b/\]; $1/g'
	while [ $# -ne 0 ]; do
		echo -e "\033[1;32m=== $1 ===\033[0m"
		if [ -n "$dryrun" ]; then
			diff "$1" <(perl -0pe "$cmd" "$1")
		else
			perl -i -0pe "$cmd" "$1"
		fi
		shift
	done
}

sudo_wrapper ()
{
	case "$*" in
	-*)
		\sudo "$@";;
	*)
		\sudo env "PATH=$PATH" "$@";;
	esac
}

is_power_of_2 ()
{
	if (( $1 != 0 )) && (( ( $1 & ( $1 - 1 ) ) == 0 )); then
		echo YES
		return 0
	else
		echo NO
		return 1
	fi
}

artifacts_unpack ()
{
	(
		base="$PWD"

		if [ -n "${ZSH_VERSION}" ]; then
			setopt CSH_NULL_GLOB
		else
			shopt -s nullglob
		fi

		for f in "$@"; do
			cd "$f"
			cat   ./*.tar.gz ./*.tgz | tar xzi
			rm -f ./*.tar.gz ./*.tgz
			cd "$base"
		done
	)
}

h ()
{
	help -m "$@" | less
}

md ()
{
	if [ -z "$1" ]; then
		echo "md <dir_name>"
		return 0
	fi
	mkdir -p "$1"
	cd "$1"
}

nvr_reset_mouse()
{
	setopt LOCAL_OPTIONS NO_NOTIFY NO_MONITOR
	( sleep 1
	nvr --nostart --remote -c 'set mouse=' -c 'set mouse=a'
	) >/dev/null 2>&1 & disown >/dev/null 2>&1
}

v()
{
	local -a v

	if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
		v=( nvr --nostart )
		if [ "$1" != '--remote-tab' ]; then
			if [ $# -gt 1 ]; then
				v+=( --remote-tab )
			else
				v+=(
				-c "let b:nvr_term = bufnr('#')"
				-c 'let b:nvr_jump = b:nvr_term'
				-c 'nnoremap <buffer> ZQ :call Go_Back(0)<cr>i'
				-c 'nnoremap <buffer> ZZ :call Go_Back(1)<cr>i'
				--remote
				)
			fi
		fi
	else
		v=( vim -p )
	fi

	if [ $# -eq 0 ] && [ -z "$NVIM_LISTEN_ADDRESS" ]; then
		if [ "$(uname)" != Darwin ]; then
			local oldterm=$TERM
			TERM=putty-256color

			# fix weird bug with abduco detach and TERM=putty
			if [ -e /tmp/nvimsocket ]; then
				v=(
				-c 'noremap  <s-left>  <left>'
				-c 'noremap  <s-right> <right>'
				-c 'noremap! <s-left>  <left>'
				-c 'noremap! <s-right> <right>'
				-c 'tnoremap <s-left>  <left>'
				-c 'tnoremap <s-right> <right>'
				-c 'noremap  <left>  <c-left>'
				-c 'noremap  <right> <c-right>'
				-c 'noremap! <left>  <c-left>'
				-c 'noremap! <right> <c-right>'
				-c 'tnoremap <left>  <c-left>'
				-c 'tnoremap <right> <c-right>'
				)
				nvr --nostart --remote "${v[@]}"
				nvr_reset_mouse
			fi
		fi

		abduco -A nvim nvim --listen /tmp/nvimsocket +term
		if [ -n "$oldterm" ]; then
			TERM=$oldterm
		fi
	elif [ $# -ne 0 ] || [ -t 0 ]; then
		"${v[@]}" "$@"
	else
		"${v[@]}" -
	fi
}

vv()
{
	v --remote-tab "$@"
}

chpwd()
{
	if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
		setopt LOCAL_OPTIONS NO_NOTIFY NO_MONITOR
		nvr --nostart --remote "+lcd $PWD" >/dev/null 2>&1 & disown >/dev/null 2>&1
	fi
}

if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
	export VISUAL="nvr-wrapper.sh"
else
	export VISUAL="nvim -p"
fi

ramdisk_toggle()
{
	local size
	if [ -e /dev/ram0 ]; then
		if [ -z "$1" ]; then
			echo -n "Remove ramdisk module? "
			read -r size
		fi
		echo sudo modprobe -r brd
		sudo modprobe -r brd
	else
		if [ -z "$1" ]; then
			echo -n "Size for ramdisk: "
			read -r size
		else
			size="$1"
		fi
		size="$(( $(convert_to_bytes "$size") / 1024 ))"
		echo sudo modprobe brd rd_size="$size"
		sudo modprobe brd rd_size="$size"
	fi
}

arc_get_message()
{
	if [ -z "$1" ]; then
		echo >&2 "Usage: ${FUNCNAME[0]} <revision_id>"
		return 1
	fi

	echo '{"revision_id":"'"${1##*D}"'","edit":"false"}' | arc call-conduit differential.getcommitmessage | \
		\grep -Po '(?<="response":").+(?="\}$)' | sed -e 's/\\n/\n/g' -e 's,\\/,/,g'
}

cdw()
{
	local i
	if [ -n "$BASH_VERSION" ]; then
		i=0 # BASH arrays start at 0
	elif [[ "$(setopt)" != *ksharrays* ]]; then
		i=1 # ZSH arrays start at 1
	fi

	if [ "$PWD" = "${CD_WORK_DIR[i]}" ]; then
		\cd "${CD_WORK_DIR[i+1]}"
	else
		\cd "${CD_WORK_DIR[i]}"
	fi
}

renew_kpass()
{
	local pass kt
	if [ -n "$1" ]; then
		pass="$1"
	else
		echo -n 'Password: '
		read -r -s pass
	fi

	kt="$HOME/nefedov.keytab"
	rm -f "$kt"

	printf '%s\n%s\n%s\n%s\n' \
		'addent -password -p nefedov -k 1 -e aes256-cts' \
		"$pass" \
		"wkt $kt" \
		'quit' | ktutil
}

xdocker()
{
	local XAUTH=/tmp/.docker.xauth
	touch "$XAUTH"
	xauth nlist "$DISPLAY" | sed -e 's/^..../ffff/' | \
		xauth -f "$XAUTH" nmerge -
	chmod 777 "$XAUTH"
	docker run -it -e "DISPLAY=$DISPLAY" -v "$XAUTH:$XAUTH" \
		-e "XAUTHORITY=$XAUTH" "--net=host" "$@"
}

funcgrep ()
{
	local opt cmd
	if [ "$1" = '-d' ]; then
		opt='-i'
		cmd='d'
		shift
	else
		opt='-n'
		cmd='p'
	fi
	local func="$1"
	if [ -z "$1" ]; then
		func='\w\+'
	fi
	shift
	if [ -z "$1" ]; then
		set -- *
	fi
	sed -r $opt "/$func\\s*\\(\\)/,/^\\s*}/$cmd" "$@"
}

