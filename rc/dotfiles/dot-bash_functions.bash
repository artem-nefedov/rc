
convert_to_bytes()
{
	local v=${1%i}
	case "$v" in
		*[kK]|*[kK][bB])
			echo "$(( ${v%[kK]*} * 1024 ))";;
		*[mM]|*[mM][bB])
			echo "$(( ${v%[mM]*} * 1024 * 1024 ))";;
		*[gG]|*[gG][bB])
			echo "$(( ${v%[gG]*} * 1024 * 1024 * 1024 ))";;
		*)
			echo "${v%[bB]}";;
	esac
}

is_inside_git()
{
	if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = 'true' ]; then
		return 0
	else
		return 1
	fi
}

dirdiff()
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

tonix()
{
	if [ -z "$1" ]; then
		sed 's,\\,/,g'
	else
		echo "${@//\\//}"
	fi
}

stylize()
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
	# shellcheck disable=2016
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

artifacts_unpack()
{
	(
		base="$PWD"

		if [ -n "${ZSH_VERSION}" ]; then
			setopt CSH_NULL_GLOB
		else
			shopt -s nullglob
		fi

		for f in "$@"; do
			cd "$f" || return 1
			cat   ./*.tar.gz ./*.tgz | tar xzi
			rm -f ./*.tar.gz ./*.tgz
			cd "$base" || return 1
		done
	)
}

h()
{
	help -m "$@" | less
}

md()
{
	if [ -z "$1" ]; then
		echo "md <dir_name>"
		return 0
	fi
	mkdir -p "$1"
	cd "$1" || return 1
}

v()
{
	local -a v

	if [ -n "$NVIM" ]; then
		if [ $# -eq 0 ] && [ -t 0 ]; then
			nvim --server "$NVIM" --remote-send "<cmd>FindFileToUseAsArgument v<cr>"
			return
		fi

		v=( nvr --nostart )
		if [ "$1" != '--remote-tab' ]; then
			if [ $# -gt 1 ]; then
				v+=( --remote-tab )
			else
				v+=(
				-c "let b:nvr_jump = bufnr('#')"
				-c 'nnoremap <buffer> ZQ <cmd>call GoBack(0)<cr>i'
				-c 'nnoremap <buffer> ZZ <cmd>call GoBack(1)<cr>i'
				--remote
				)
			fi
		fi
	else
		v=( vim -p )
	fi

	if [ $# -eq 0 ] && [ -z "$NVIM" ]; then
		if [ -e /tmp/nvimsocket ]; then
			nvr_reset_mouse
		fi

		if ! killall -0 nvim 2>/dev/null; then
			rm -f /tmp/nvimsocket
		fi

		nvim --listen /tmp/nvimsocket +term
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

if [ -n "$NVIM" ]; then
	export VISUAL="nvr-wrapper.sh"
else
	export VISUAL="nvim -p"
fi

cdr()
{
	local d="$PWD"
	while [ ! -d "$d/.git" ]; do
		d=${d%/*}
		test -n "$d" || break
	done

	if [ -n "$d" ]; then
		cd "$d" || return
	else
		echo >&2 "Git root not found"
		return 1
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
	local name version

	if [[ "$1" != '-f' ]]; then
		echo >&2 "'-f' not specified - performing dry-run"
	fi

	name=''

	while IFS='' read -r version; do
		if [[ "$version" == ' '* ]]; then
			read -r version <<< "$version"
			if [[ "$version" != '*'* ]]; then
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

p()
{
	if [[ "$*" == '-' ]]; then
		echo "Unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN"
		unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
		return 0
	fi

	if [[ "${AWS_ACCESS_KEY_ID+x} ${AWS_SECRET_ACCESS_KEY+x} ${AWS_SESSION_TOKEN+x}" == *x* ]]; then
		echo >&2 "WARNING: Session-specific AWS variables are set (clear with '-')"
	fi

	case $# in
		1 )
			echo "Set AWS_PROFILE to '$1'"
			export AWS_PROFILE="$1"
			;;
		0 )
			echo "Unset AWS_PROFILE"
			unset AWS_PROFILE
			;;
		* )
			echo >&2 "Too many arguments. AWS_PROFILE value, '-', or nothing expected."
			return 1
			;;
	esac

	chpwd # force redraw statusline
}

inc_chart_rc_ver()
{
	local field old_ver new_ver rc chart
	local delete_rc=false

	if [ "$1" = '-d' ]; then
		delete_rc=true
		shift
	fi

	while [ $# -ne 0 ]; do
		echo "With directory '$1'"
		chart="$1/Chart.yaml"
		if [ ! -f "$chart" ]; then
			echo >&2 "'$1' is not a chart directory"
			return 1
		fi

		for field in version appVersion; do
			old_ver=$(sed -rn "s/^${field}: (.+)$/\\1/p" "$chart")

			if $delete_rc; then
				new_ver="${old_ver%%-*}"
			else
				rc=${old_ver##*.}
				rc=$(( rc + 1 )) || return 1
				new_ver="${old_ver%.*}.$rc"
			fi

			sed -r -i.bu "s/^(${field}:) .+$/\\1 ${new_ver}/" "$chart"
			rm -f "${chart}.bu"
		done

		echo "From '$old_ver' to '$new_ver'"
		shift
	done
}

update_arc() {
	local file
	file=$(jfrog rt search '**/arc-cli_Darwin_arm64.tar.gz' \
		| jq -er '[ .[] | select(.props["build.number"][0] | test("^[0-9]+[.][0-9]+[.][0-9]+$")) ] | sort_by(.created) | last | .path') || return 1
	rm -rf arc-cli-dist
	jfrog rt dl --explode "$file" || return 1
	mv -v arc-cli-dist/*/arc "$HOME/bin/"
	rm -rf arc-cli-dist
}

call_vim_cmd() {
	nvim --server "$NVIM" --remote-send "<cmd>${*}<cr>"
}

kap() {
	kubectl get pod -A --field-selector spec.nodeName="$1"
}

knn() {
	local node
	node=$(kubectl get pod -o yaml "$@" | "grep" --color=auto nodeName:)
	if [ -n "$node" ]; then
		echo "$node"
		kubectl get nodeclaim | "grep" -F "${node##* }"
	else
		return 1
	fi
}

commit_from_changelog() {
	(
		cdr

		msg=$(git --no-pager diff --no-color CHANGELOG.md | grep -E '^[+]([*]|##) ')

		if [ -z "$msg" ]; then
			msg=$(git --no-pager diff --no-color --cached CHANGELOG.md | grep -E '^[+]([*]|##) ')
		fi

		if [[ "$msg" == *$'\n'* ]]; then
			msg=$(grep -Ev '^[+]## ' <<< "$msg")
		fi

		if [[ "$msg" == *$'\n'* ]]; then
			echo "Too many change lines"
		elif [ -n "$msg" ]; then
			if [[ "$msg" == "+## "* ]]; then
				msg="MINOR Prepare for release ${msg#* }"
			else
				msg=${msg#* }
			fi
			git commit -a -m "$msg"
		else
			echo "No changes in CHANGELOG.md to commit"
		fi
	)
}

if [ -n "$ZSH_VERSION" ]; then
	# shellcheck disable=2154
	(( $+functions[_git-sw] )) ||
	_git-sw() {
		# shellcheck disable=2034
		local curcontext="$curcontext" state line expl ret=1
		# shellcheck disable=2034
		local -A opt_args

		# shellcheck disable=2086
		_arguments -C -s -S $endopt \
			'1: :->branches' && ret=0

		_alternative \
			'branches::__git_branch_names' && ret=0

		return $ret
	}
fi
