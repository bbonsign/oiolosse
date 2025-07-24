#!/usr/bin/env nu

# let kitty_socket = $"unix:/tmp/kitty.socket-($env.KITTY_PID)"
use ~/.config/nushell/scripts/bb *

let windows = ky windows

if ($windows | is-empty) {
  # No inactive tabs found
  return
}

let goto_id = $windows | fzy-get --preview_group_by "session" win_id 

kitty @ focus-window --match=$"id:($goto_id)"

