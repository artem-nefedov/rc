## functions that break bash-language-server

nvr_reset_mouse()
{
	setopt LOCAL_OPTIONS NO_NOTIFY NO_MONITOR
	( sleep 1
	nvr --nostart --remote -c 'set mouse=' -c 'set mouse=a'
	) >/dev/null 2>&1 &!
}

chpwd()
{
	if [ -n "$NVIM" ] && [ -n "$NVIM_BUF_ID" ] && [ -z "$WIDGET" ] && [ "$ZSH_SUBSHELL" -eq 0 ]; then
		setopt LOCAL_OPTIONS NO_NOTIFY NO_MONITOR
		(
		branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || echo --)
		kubectx=$(yq -e '.["current-context"]' "$HOME/.kube/config" 2>/dev/null || echo /--)

		if [[ "$kubectx" == */* ]]; then
			kubectx=${kubectx##*/}
		else
			kubectx=${kubectx##*@}
			kubectx=${kubectx%%.*}
		fi

		if [[ "${AWS_ACCESS_KEY_ID+x} ${AWS_SECRET_ACCESS_KEY+x} ${AWS_SESSION_TOKEN+x}" == *x* ]]; then
			aws_profile='SESSION'
		else
			aws_profile="${AWS_PROFILE-}${AWS_REGION+@${AWS_REGION}}"
		fi

		gh_profile=$(yq -e '.["github.com"].user' "$HOME/.config/gh/hosts.yml" || echo '')

		case "$gh_profile" in
		artem-nefedov ) gh_profile='personal';;
		anefedov_align ) gh_profile='align';;
		'' ) gh_profile='--';;
		esac

		nvim --server "$NVIM" \
			--remote-send "<cmd>silent TerminalStatusUpdate $NVIM_BUF_ID $PWD $branch $kubectx $aws_profile $gh_profile<cr>" \
			>/dev/null 2>&1 ) >/dev/null 2>&1 &!
	fi
}

_periodic_chpwd()
{
	if [ -n "${_skip_periodic_trigger-}" ]; then
		unset _skip_periodic_trigger
		return 0
	fi
	chpwd
}

# shellcheck disable=2034
PERIOD=3
# shellcheck disable=2034
periodic_functions=( _periodic_chpwd )
