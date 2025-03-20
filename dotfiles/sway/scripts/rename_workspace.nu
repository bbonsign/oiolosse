#!/usr/bin/env nu

let name = swaymsg --raw -t get_workspaces | from json | where focused == true | get name |swaymsg --raw -t get_workspaces | from json | where focused == true | get name.0 | wmenu -p "New name for this workspace "
swaymsg rename workspace to $name
