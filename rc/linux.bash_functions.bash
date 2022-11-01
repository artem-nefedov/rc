
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
	local -a find=( find . \( \! -path '*/.git/*' -a \! -path '*/.svn/*' \) )

	if [ "$(uname)" = Darwin ]; then
		local -a stat=( xargs -0 stat -f $'%z\t%N' )
		gstat=gstat
	else
		local -a stat=( xargs -0 stat -c $'%s\t%n' )
		gstat=stat
	fi

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
				$diff   <(cd "$1" && "${find[@]}" -print0 | sort -z | "${stat[@]}") \
					<(cd "$2" && "${find[@]}" -print0 | sort -z | "${stat[@]}")
				;;
			file)
				$diff   <(cd "$1" && "${find[@]}" -print0 | sort -z | xargs -0 file) \
					<(cd "$2" && "${find[@]}" -print0 | sort -z | xargs -0 file)
				;;
			stat)
				$diff   <(cd "$1" && "${find[@]}" -print0 | sort -z | xargs -0 "$gstat" -c $'%A %h %U %G\t%n') \
					<(cd "$2" && "${find[@]}" -print0 | sort -z | xargs -0 "$gstat" -c $'%A %h %U %G\t%n')
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

	if [ "$1" = '-r' ] && [ $# -eq 3 ]; then
		set -- "scp://$2/$3"
	fi

	if [ -n "$NVIM" ]; then
		v=( nvr --nostart )
		if [ "$1" != '--remote-tab' ]; then
			if [ $# -gt 1 ]; then
				v+=( --remote-tab )
			else
				v+=(
				-c "let b:nvr_jump = bufnr('#')"
				-c 'nnoremap <buffer> ZQ :call Go_Back(0)<cr>i'
				-c 'nnoremap <buffer> ZZ :call Go_Back(1)<cr>i'
				--remote
				)
			fi
		fi
	else
		v=( vim -p )
	fi

	if [ $# -eq 0 ] && [ -z "$NVIM" ]; then
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
		else
			if [ -e /tmp/nvimsocket ]; then
				nvr_reset_mouse
			fi
		fi

		if ! pgrep -q nvim; then
			rm -f /tmp/nvimsocket
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
	if [ -n "$NVIM" ] && [ -z "$WIDGET" ] && [ "$ZSH_SUBSHELL" -eq 0 ]; then
		setopt LOCAL_OPTIONS NO_NOTIFY NO_MONITOR
		nvr --nostart --remote \
			-c "let b:terminal_pwd = '$PWD'" \
			-c "lcd $PWD" >/dev/null 2>&1 & disown >/dev/null 2>&1
	fi
}

if [ -n "$NVIM" ]; then
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

cdr()
{
	local d="$PWD"
	while [ ! -d "$d/.git" ]; do
		d=${d%/*}
		test -n "$d" || break
	done

	if [ -n "$d" ]; then
		cd "$d"
	else
		echo >&2 "Git root not found"
		return 1
	fi
}

renew_kpass()
{
	local pass kt principal
	local admin='-admin'

	if [ "$1" = '-u' ]; then
		admin=''
		shift
	fi

	principal="$(whoami)${admin}"
	kt="$HOME/${principal}.keytab"
	echo "Renewing $kt"

	if [ -n "$1" ]; then
		pass="$1"
	else
		echo -n 'Password: '
		read -r -s pass
	fi

	rm -f "$kt"

	if [ "$(uname)" = Darwin ]; then
		ktutil -k "$kt" add \
			--password="$pass" \
			-p "${principal}@ALIGNTECH.COM" \
			-e aes256-cts-hmac-sha1-96 \
			-V 1
	else
		printf '%s\n%s\n%s\n%s\n' \
			"addent -password -p ${principal} -k 1 -e aes256-cts" \
			"$pass" \
			"wkt $kt" \
			'quit' | ktutil
	fi
}

ki()
{
	local principal
	local admin='-admin'

	if [ "$1" = '-u' ]; then
		admin=''
		shift
	fi

	principal="$(whoami)${admin}"
	kt="$HOME/${principal}.keytab"
	echo "Using $kt"

	kinit -t "$kt" "${principal}@ALIGNTECH.COM"
	klist
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

f()
{
	local b
	test -n "${2-}" || { echo >&2 bad format; return 1; }
	b=$(echo "${*// /_}" | tr '[:upper:]' '[:lower:]' \
		| awk -F- '{print toupper($1)"-"$2}')
	b="feature/$b"
	if git rev-parse -q --verify "$b" >/dev/null; then
		git checkout "$b"
	else
		git checkout -b "$b"
	fi
}

unalias gpr 2>/dev/null || true

gpr()
{
	local f1 f2 line
	while IFS='' read -r line; do
		printf '%s\n' "$line"
		# shellcheck disable=SC2034
		read -r f1 f2 <<< "$line"
		if [[ "$f2" == https://* ]]; then
			open "$f2"
		fi
	done < <(git push -u 2>&1)
}

aws()
{
	local help=false
	local -a cmd

	case "$1" in
		cfn)
			shift
			set -- cloudformation "$@"
			;;
		r53)
			shift
			set -- route53 "$@"
			;;
	esac

	while [ $# -ne 0 ]; do
		case "$1" in
			c|-c)
				cmd+=( '--region' 'cn-north-1' )
				;;
			-p)
				cmd+=( '--profile' )
				;;
			h|-h|help|--help)
				cmd+=( help )
				help=true
				;;
			*)
				cmd+=( "$1" )
				;;
		esac
		shift
	done

	if $help; then
		/usr/local/bin/aws "${cmd[@]}"
	else
		PAGER='' /usr/local/bin/aws "${cmd[@]}"
	fi
}

kconf_unset()
{
	# $1 = cluster name, $2-$... = region(s)
	if [ $# -lt 1 ]; then
		echo >&2 "Usage: kconf_unset cluster region_1 [region_2 ...]"
		echo >&2 "       kconf_unset context_name"
		return 1
	fi

	if [[ "$SHELL" == */zsh ]]; then
		setopt local_options BASH_REMATCH KSH_ARRAYS
	fi

	local user line type region cluster
	local aws_name_pattern eksctl_cluster_name_pattern eksctl_context_name_pattern
	local type_pattern='^([[:lower:]]+):$'
	user=$(whoami)

	if [ $# -eq 1 ]; then
		aws_name_pattern='^arn:aws(-cn)?:eks:([^:]+):[0-9]+:cluster/(.+)$'
		eksctl_context_name_pattern="^$user"'@aligntech\.com@([^.]+)\.([^.]+)\.eksctl\.io$'

		if [[ "$1" =~ $aws_name_pattern ]]; then
			cluster=${BASH_REMATCH[3]}
		elif [[ "$1" =~ $eksctl_context_name_pattern ]]; then
			cluster=${BASH_REMATCH[1]}
		else
			echo >&2 "Bad context name: $1"
			return 1
		fi

		set -- "${BASH_REMATCH[2]}"
	else
		cluster=$1
		shift
	fi

	while [ $# -ne 0 ]; do
		region=$1
		aws_name_pattern=" name: (arn:aws(-cn)?:eks:${region}:[0-9]+:cluster/${cluster})\$"
		eksctl_cluster_name_pattern=" name: (${cluster}\\.${region}\\.eksctl\\.io)\$"
		eksctl_context_name_pattern=" name: (${user}@aligntech\\.com@${cluster}\\.${region}\\.eksctl\\.io)\$"

		while IFS='' read -r line; do
			if [[ "$line" =~ $type_pattern ]]; then
				type=${BASH_REMATCH[1]}
			elif [[ "$line" =~ $aws_name_pattern ]] \
			|| [[ "$line" =~ $eksctl_cluster_name_pattern ]] \
			|| [[ "$line" =~ $eksctl_context_name_pattern ]]; then
				kubectl config unset "${type}.${BASH_REMATCH[1]}"
			fi
		done < <(kubectl config view)

		shift
	done
}

clean_asdf_versions()
{
	local name version source
	local -A versions

	if [[ "$1" != '-f' ]]; then
		echo >&2 "'-f' not specified - performing dry-run"
	fi

	# shellcheck disable=2034
	while read -r name version source; do
		versions[$name]="$version"
	done < <(asdf current)

	name=''

	while IFS='' read -r version; do
		if [[ "$version" == ' '* ]]; then
			read -r version <<< "$version"
			if [[ "${versions[${name:?}]}" != "$version" ]]; then
				if [[ "$1" == '-f' ]]; then
					asdf uninstall "$name" "$version"
				else
					echo asdf uninstall "$name" "$version"
				fi
			fi
		else
			name=$version
		fi
	done < <(asdf list)
}

crossplane_query() {
	local refs no_name
	refs=$(set -x; kubectl get "$1" -l "crossplane.io/claim-namespace=$2,crossplane.io/claim-name=$3" -o jsonpath='{.items[*].spec.resourceRefs}')
	kubectl get $(jq -r '.[] | select(.name) | .kind + "." + (.apiVersion|split("/")[0]) + "/" + .name' <<< "$refs")
	no_name=$(jq -r '.[] | select(.name == null)' <<< "$refs")
	test -z "$no_name" || printf '\n === RESOURCES WITH NO NAME ===\n\n%s\n' "$no_name"
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
