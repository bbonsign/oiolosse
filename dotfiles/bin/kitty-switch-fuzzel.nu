#!/usr/bin/env nu

use ~/.config/nushell/scripts/bb/ky.nu *

let kitty_socket = ky socket
let active_sessions = (kitty @ --to $kitty_socket ls | from json | get wm_class | str substring 6..)
let session =  (ky | where { $in not-in $active_sessions } | to text | fuzzel --dmenu )

ky session start $session

