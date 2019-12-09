#!/bin/bash

trap 'echo "$0: Error at $LINENO: $BASH_COMMAND"; exit 1;' ERR

test -n "$1"
cmd=( "$@" )

"${cmd[@]}" <<-'EOF'
BEGIN;
DROP VIEW IF EXISTS audit.simple_logged_actions;
CREATE VIEW audit.simple_logged_actions AS
SELECT table_name AS table,
	regexp_replace(
		substring(
			(row_data)::text from '"[iI][dD]"=>"[[:digit:]]+"'
		), '[^[:digit:]]', '', 'g'
	) AS id,
	(CASE action WHEN 'U' THEN changed_fields WHEN 'I' THEN row_data ELSE NULL END) AS change,
	date_trunc('second', (action_tstamp_tx)::timestamp) AS date,
	action AS "A",
	session_user_name AS user
FROM audit.logged_actions
ORDER BY logged_actions.event_id DESC;
COMMIT;

SELECT * FROM audit.simple_logged_actions LIMIT 1;
EOF

