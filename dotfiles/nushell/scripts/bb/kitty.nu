const sessions_dir = "~/.config/kitty/sessions" | path expand

def _sessions_files [] {
  ls $sessions_dir | get name | path basename 
}

export def "ky windows" [] {
  kitty @ ls
  | from json
  | select wm_class tabs is_active
  | each {|os_window|
    $os_window.tabs
    | each {|tab|
      let tab_windows = $tab.windows 
      | select id title is_active
      | rename --column {id: win_id, is_active: win_is_active, title: win_title}
      | each {|win|
        mut w = $win
        $w.session = $os_window.wm_class | str replace "kitty-" ""
        $w.session_is_active = $os_window.is_active
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
  | where {not ($in.tab_is_active and $in.session_is_active)}
  | select  session tab_title win_title tab_is_active win_is_active session_is_active tab_id win_id
  | flatten
}

export def "ky tabs" [] {
  kitty @ ls
  | from json
  | select wm_class tabs is_active
  | each {|os_window|
    $os_window.tabs
    | each {|tab|
      mut t = $tab
      $t.session = $os_window.wm_class | str replace "kitty-" ""
      $t.session_is_active = $os_window.is_active
      $t.tab_is_active = $tab.is_active
      $t.tab_id = $tab.id
      $t.tab_title = $tab.title
      $t
    }
  }
  | flatten
  # | where {not ($in.tab_is_active and $in.session_is_active)}
  | select tab_id tab_title tab_is_active session session_is_active
  # | flatten
}

export def "ky session create" [session_name: string@"_sessions_files"] {
  let session_path = $sessions_dir | path join $session_name
  if (not ($session_path | path exists)) {
    print "Session '$session_name' does not exist." | error
    return
  }

  let kitty_name = $"kitty-($session_name)"

  (
    kitty
    --detach
    --single-instance
    --session $session_path
    --app-id $kitty_name
    --title $kitty_name
  )
}

# export def "ky session ls" [] {
#   kitty @ ls
#   | from json
#   | select wm_class tabs is_active
#   | each {|os_window|
#     $os_window.tabs
#     | each {|tab|
#       let tab_windows = $tab.windows 
#       | select id title is_active
#       | rename --column {id: win_id, title: win_title}
#       | each {|win|
#         mut w = $win
#         $w.session = $os_window.wm_class | str replace "kitty-" ""
#         $w.session_is_active = $os_window.is_active
#         $w.tab_is_active = $tab.is_active
#         $w.tab_id = $tab.id
#         $w.tab_title = $tab.title
#         $w
#       }
#       $tab_windows
#     }
#   }
#   | flatten
#   | flatten
#   | where {not ($in.tab_is_active and $in.session_is_active)}
#   | select  tab_title win_title session win_id tab_id 
#   | flatten
# }
