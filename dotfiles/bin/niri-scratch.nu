#!/usr/bin/env nu
# From: https://github.com/GregorySchwartz/dotfiles/blob/master/.config/niri/move_window.sh

# Usage: ./move_window "KeePassXC" "keepassxc"

def _do [title: string, command: string] {
  let windows = (niri msg --json windows | from json)
  let workspaces = (niri msg --json workspaces | from json)
  let window =  ($windows | where title == $title | get 0?)
  let scratch_workspace = ($workspaces | where name == "z" | first)
  let focused_workspace = ($workspaces | where is_focused | first)
  let focused_workspace_location = if ($focused_workspace.name | is-not-empty) {$focused_workspace.name } else {$focused_workspace.idx}

  if ($window | is-not-empty) {
    # Determine if the window is in the current workspace (send to scratch) or if
    # it is in scratch (send to current workspace).
    if ($window.workspace_id == $focused_workspace.id) {
      niri msg action move-window-to-workspace --focus "false" --window-id $window.id $scratch_workspace.name
      niri msg action center-window --id $window.id
    } else {
      # niri msg action move-window-to-floating --id $id
      niri msg action move-window-to-workspace --window-id $window.id ($focused_workspace_location)
      niri msg action center-window --id $window.id
      niri msg action focus-window --id $window.id
    }
  } else {
    # Program not running, so run it.
    # Add window-rules to make it floating, spawn on scratch_workspace, etc
    sh -c $"($command)"
  }
}

_do "kitty-scratch" "bash -c 'kitty --override allow_remote_control=no --override background_opacity=0.8 || $HOME/.local/kitty.app/bin/kitty --override allow_remote_control=no --override background_opacity=0.8 --title kitty-scratch'"
