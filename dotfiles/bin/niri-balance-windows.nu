#!/usr/bin/env nu

# type workspace = record<id: int, idx: int, name: string, output: string, is_active: bool, is_focused: bool, active_window_id: int>
# type windows -> table<id: int, title: string, app_id: string, pid: int, workspace_id: int, is_focused: bool, is_floating: bool>

def current_workspace []: [
any -> record<id: int, idx: int, name: string, output: string, is_active: bool, is_focused: bool, active_window_id: int>
] {
  niri msg --json workspaces | from json | where is_focused | get 0
}

def non_floating_windows_on_workspace [workspace_id: int]: [
    any -> table<id: int, title: string, app_id: string, pid: int, workspace_id: int, is_focused: bool, is_floating: bool>
  ] {
  niri msg --json windows | from json  | where workspace_id == $workspace_id | where not is_floating
}

  def set_column_width [window_id: int, width_percent: float] {
  niri msg action focus-window --id $window_id
  niri msg action set-column-width $"($width_percent)%"
}

def main [] {
  let current_workspace = (current_workspace).id
  let windows = non_floating_windows_on_workspace $current_workspace
  let focused_window = $windows | where is_focused | get 0
  let percent = 100 / ($windows | length)
  $windows | each { set_column_width $in.id $percent}
  niri msg action focus-window --id $focused_window.id
}
