#!/usr/bin/env nu

# Move every Niri output to its last workspace (which is empty), then hide the Noctalia bar.

# Optionally hide the intermediate focus changes with:
# ^niri msg action do-screen-transition --delay-ms 150 | ignore

^niri msg --json workspaces
| from json
| group-by output
| transpose output workspaces
| each {|monitor|
  let last_workspace = ($monitor.workspaces | sort-by idx | last)
  if not $last_workspace.is_active {
    ^niri msg action focus-monitor $monitor.output | ignore
    ^niri msg action focus-workspace $last_workspace.idx | ignore
  }
}
| ignore

^noctalia msg bar-hide
