#!/bin/bash

trap 'echo "$0: Error at $LINENO: $BASH_COMMAND"; exit 1;' ERR

# to use with audit trigger from here:
# https://github.com/2ndQuadrant/audit-trigger

test -n "$1"
cmd=( "$@" )

# shellcheck disable=SC2162,SC2034
while IFS='|' read -r a field b; do
	read -r table <<< "$field"
	if [ -z "$table" ]; then
		continue
	fi

	trigger="${table// /_}_audit"
	echo "Using table [$table] and trigger [$trigger] ..."

	"${cmd[@]}" <<-EOF
	BEGIN;
	DROP TRIGGER IF EXISTS "$trigger" ON "$table";
	CREATE TRIGGER "$trigger"
	AFTER INSERT OR UPDATE OR DELETE ON "$table" FOR EACH ROW
	EXECUTE PROCEDURE audit.if_modified_func();
	COMMIT;
	EOF
done < <("${cmd[@]}" -t -c '\dt public.*')



