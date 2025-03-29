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

export def main [
  --two-thirds-main  # Make the focused window 2/3 width and the rest 1/3 width
] {
  let current_workspace = (current_workspace).id
  let windows = non_floating_windows_on_workspace $current_workspace
  let focused_window = $windows | where is_focused | get 0
  let number_of_windows = $windows | length
  let percents = if $two_thirds_main {
    [ 66.66667 ...(seq 1 ($number_of_windows - 1 )) | each {33.33333}]
  } else {
  # Equal widths
  let percent = 100 / $number_of_windows
  seq 1 $number_of_windows | each {$percent}
}

$windows | zip $percents | each { set_column_width $in.0.id $in.1}
niri msg action focus-window --id $focused_window.id
}
