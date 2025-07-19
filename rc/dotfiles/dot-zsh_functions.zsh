## functions that break bash-language-server

chpwd()
{
	if [ -n "$NVIM" ] && [ -z "$WIDGET" ] && [ "$ZSH_SUBSHELL" -eq 0 ]; then
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
			profile='SESSION'
		else
			profile="${AWS_PROFILE-}${AWS_REGION+@${AWS_REGION}}"
		fi

		nvim --server "$NVIM" \
			--remote-send "<cmd>silent TerminalStatusUpdate $PWD $branch $kubectx $profile<cr>" \
			>/dev/null 2>&1 ) >/dev/null 2>&1 &!
	fi
}

# shellcheck disable=2034
PERIOD=3
# shellcheck disable=2034
periodic_functions=( chpwd )
