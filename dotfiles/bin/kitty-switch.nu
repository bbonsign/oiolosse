#!/usr/bin/env nu

# let kitty_socket = $"unix:/tmp/kitty.socket-($env.KITTY_PID)"
use ~/.config/nushell/scripts/bb *

let windows = kitty @ ls
| from json
| select wm_class tabs is_active
| each {|os_window|
  $os_window.tabs
  | each {|tab|
    let tab_windows = $tab.windows 
    | select id title is_active
    | rename --column {id: win_id}
    | each {|win|
      mut w = $win
      $w.wm_class = $os_window.wm_class
      $w.os_window_is_active = $os_window.is_active
      $w.tab_is_active = $tab.is_active
      $w.tab_id = $tab.id
      $w.tab_title = $tab.title
      $w
    }
    $tab_windows
  }
}
| flatten
| flatten
| where {not ($in.tab_is_active and $in.os_window_is_active)}
| select  wm_class win_id tab_id tab_title title
| flatten

if ($windows | is-empty) {
  # No inactive tabs found
  return
}

let goto_id = $windows | fzy-get win_id

kitty @ focus-window --match=$"id:($goto_id)"

