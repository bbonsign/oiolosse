#!/usr/bin/env nu

let window = niri msg --json windows | from json | each { $'($in.id): ($in.app_id)' } | to text | fuzzel --prompt " " --dmenu | parse '{id}: {app_id}' | get 0
niri msg action focus-window --id $window.id
