#!/usr/bin/env nu

# From: https://gist.github.com/TIAcode/df897c27dc4b95ed7789a91d5c524416
#
# Nushell module implementing virtual scratchpads for Niri wm
# Usage:
# workspace "scratch" {
#   open-on-output "DP-3"
# }
# window-rule {
#   match app-id="dd_term"
#   open-floating true
#   open-focused true
#   open-on-workspace "scratch"
#   default-column-width { proportion 0.99; }
#   default-window-height { proportion 0.3; }
#   default-floating-position x=0 y=0 relative-to="top-left"
# }
# binds {
#    Mod+Backspace {
#      spawn "nu" "-c" "use /home/user/.config/niri/scratchpad/nuniri.nu *; toggle_scratchpad 'dd_term' 'kitty --app-id=dd_term'";
#    }
# }
# Saves the previously focused window to /tmp/niri_scratch so we don't need to focus the scratchpad workspace
# Can work with tiled windows as well as floating.

def get_window_by_app_id [app_id: string] {
  let windows = (
    niri msg -j windows
    | from json
    | where app_id == $app_id
  )
  if ($windows | is-empty) {
    null
  } else {
    $windows | first
  }
}

def get_window_by_id [window_id: int] {
  let windows = (
    niri msg -j windows
    | from json
    | where id == $window_id
  )
  if ($windows | is-empty) {
    null
  } else {
    $windows | first
  }
}

def get_scratch_workspace_id [] {
  niri msg -j workspaces
  | from json
  | where name == "scratch"
  | get id
  | first
}

def get_active_workspace [] {
  niri msg -j focused-window
  | from json
  | get workspace_id
}
def get_focused_window [] {
  niri msg -j focused-window
  | from json
}

def wait_for_window [app_id: string, max_attempts: int] {
  mut attempts = 0
  while $attempts < $max_attempts {
    let window = (get_window_by_app_id $app_id)
    if not ($window | is-empty) {
      return $window
    }
    sleep 100ms
    $attempts = $attempts + 1
  }
  return null
}

export def main [app_id: string, launch_cmd: string] {
  let active = (get_active_workspace)

  let previously_focused = (get_focused_window)
  mut window = (get_window_by_app_id $app_id)
  mut was_started = false
  if ($window | is-empty) {
    print $"Launching application: ($launch_cmd)"
    niri msg action do-screen-transition -d 500

    job spawn { nu -c $launch_cmd }
    $window = (wait_for_window $app_id 20) # 2 second timeout
    if ($window | is-empty) {
      echo "Failed to launch application"
      return
    } else {
      print $"Window found: ($window)"
    }
    $was_started = true
  }

  let workspace_id = $window.workspace_id
  let window_id = $window.id
  let scratch_workspace_id = (get_scratch_workspace_id)

  # Check if window is in a normal workspace and not scratch
  if $workspace_id == $active and $was_started == false {
    # Move to scratch

    let prev_focus_file = $"/tmp/niri_scratch/prev_($app_id)"
    # Check if the file exists
    if ($prev_focus_file | path exists) {
      # Load the window ID from the file
      let prev_window_id = (open $prev_focus_file | str trim | into int)
      let prev_window = (get_window_by_id $prev_window_id)
      if ($prev_window | is-empty) {
        print $"Previous window ID ($prev_window_id) not found"
      } else {
        print $"Found previous window ID: ($prev_window_id), moving window to scratch"
        niri msg action focus-window --id $prev_window_id
        niri msg action move-window-to-workspace scratch --window-id $window_id
        return
      }
    }
    niri msg action do-screen-transition -d 80
    niri msg action move-window-to-workspace scratch --window-id $window_id
    niri msg action focus-workspace $active
  } else {
    if $workspace_id == $scratch_workspace_id {
      mkdir /tmp/niri_scratch
      $previously_focused.id | save -f $"/tmp/niri_scratch/prev_($app_id)"
      print "Moving window to active workspace"
      # Move to active workspace
      niri msg action move-window-to-workspace $active --window-id $window_id
      niri msg action focus-window --id $window_id
    }
  }
}

main "kitty-scratch" "bash -c 'kitty || $HOME/.local/kitty.app/bin/kitty --class kitty-scratch'"
