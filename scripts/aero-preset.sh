#!/usr/bin/env bash

set -eu -o pipefail

update_id() {
	local id
	id=$(jq --arg n "$1" -r '.[] | select(.["app-name"] == $n) | .["window-id"]' <<< "$windows")
	win_ids["$1"]="$id"
}

move_to_ws() {
	test -n "${win_ids["$1"]-}" || return 0
	aerospace move-node-to-workspace --window-id "${win_ids["$1"]}" "$2"
}

move_to_monitor() {
	aerospace move-workspace-to-monitor --workspace "$1" "$2" || true
}

windows=$(aerospace list-windows --all --json)
declare -A win_ids

app_browser="Brave Browser"
app_term="Alacritty"
app_messenger_1="Microsoft Teams"
app_messenger_2="Telegram"
app_mail="Microsoft Outlook"

update_id "$app_browser"
update_id "$app_term"
update_id "$app_messenger_1"
update_id "$app_messenger_2"
update_id "$app_mail"

move_to_ws "$app_browser" 1
move_to_ws "$app_term" 2
move_to_ws "$app_messenger_1" 3
move_to_ws "$app_messenger_2" 3
move_to_ws "$app_mail" 4

move_to_monitor 1 3
move_to_monitor 2 2
move_to_monitor 3 1
move_to_monitor 4 1
