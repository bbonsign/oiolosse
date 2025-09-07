#!/usr/bin/env nu

# let kitty_socket = $"unix:/tmp/kitty.socket-($env.KITTY_PID)"
use ~/.config/nushell/scripts/bb *

let active_tabs = ky windows | where tab_is_active

if ($active_tabs | is-empty) {
  # No inactive tabs found
  return
}

# `--nth "1,2"` limits the fzf-search to columns 1 and 2, namely 'session' and 'tab_title'
let goto_id = $active_tabs | fzy-get --preview_group_by "session" win_id --nth "1,2"

kitty @ focus-window --match=$"id:($goto_id)"

