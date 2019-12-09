#!/bin/bash

if [ -z "$2" ]; then
	echo "
	Usage:

		${0##*/} <revision> <command> [arguments]

	Available commands:

		comment            'New Comment'
		title              'New Title'
		summary            'New Summary'
		testPlan           'New Test Plan'
		plan-changes
		request-review
		close
		reopen
		abandon
		accept
		reclaim
		reject
		commandeer
		resign
		reviewers.add      reviewer1 reviewer2 ...
		reviewers.remove   reviewer1 reviewer2 ...
		reviewers.set      reviewer1 reviewer2 ...
		subscribers.add    subscriber1 subscriber2 ...
		subscribers.remove subscriber1 subscriber2 ...
		subscribers.set    subscriber1 subscriber2 ...
"
	exit 2
fi

trap 'echo >&2 "$0: Error on $LINENO: $BASH_COMMAND"; exit 1;' ERR
set -E

if [[ "$(arc get-config project.name)" == *$'Current Source: -\n'* ]]; then
	echo >&2 "Currently not inside Phabricator-linked repository"
	exit 1
fi

phid_pattern='"phid":("[^"]+")'
get_phids()
{
	local phid list conduit scope

	if [ -n "$phid_get_users" ]; then
		conduit='user.query'
		scope='usernames'
	else
		conduit='phid.lookup'
		scope='names'
	fi

	while [ $# -ne 0 ]; do
		phid="$(echo "{\"$scope\":[\"$1\"]}" | arc call-conduit "$conduit")"
		if [[ "$phid" =~ $phid_pattern ]]; then
			list+=",${BASH_REMATCH[1]}"
		else
			echo >&2 "Not a PHID: [$phid]"
			exit 1
		fi
		shift
	done

	list="${list#','}"
	if [ -n "$phid_get_list" ]; then
		list="[$list]"
	fi

	echo -n "$list"
}

rev_id="D${1##*D}"
rev_phid="$(get_phids "$rev_id")"

if [[ "$rev_phid" == \"PHID-DREV-* ]]; then
	echo "Using [$rev_id] -> [$rev_phid].."
else
	echo >&2 "Bad revision ID: [$rev_id]"
	exit 1
fi

cmd="$2"
shift 2

case "$cmd" in
	reviewers.*|subscribers.*)
		phid_get_users=1
		;;
esac

if [ -n "$1" ]; then
	if [ -n "$2" ] || [ -n "$phid_get_users" ]; then
		phid_get_list=1
		encoded_value="$(get_phids "$@")"
	else
		case "$1" in
			true|false)
				encoded_value="$1"
				;;
			*)
				encode_cmd='echo json_encode(file_get_contents("php://stdin"));'
				encoded_value="$(printf %s "$1" | php -r "$encode_cmd")"
				;;
		esac
	fi
	value=',"value":'"$encoded_value"
fi

echo "Calling [$cmd]${1:+" [$encoded_value]"}"

err="$(echo '{"objectIdentifier":'"$rev_phid," \
	'"transactions":[{"type":"'"$cmd\"$value}]}" | \
	arc call-conduit differential.revision.edit)"

if [[ "$err" == *'"error":null'* ]]; then
	echo 'SUCCESS'
else
	err="${err//\\n/$'\n'}"
	echo 'FAIL'
	echo >&2 'RESPONSE:'
	echo >&2 "${err//\",\"/\",$'\n'\"}"
	exit 1
fi

exit 0

