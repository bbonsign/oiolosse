const sessions_dir = "~/.config/kitty/sessions" | path expand

def _sessions_files [] {
  ls $sessions_dir | get name | path basename
}

export def main [] {
  _sessions_files
}

export def "ky socket" [] {
  let kitty_socket = ls /tmp | get name | where { $in like "kitty" } | get 0
  $"unix:($kitty_socket)"
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
      | rename --column {id: win_id title: win_title}
      | each {|win|
        mut w = $win
        $w.session = $os_window.wm_class | str replace "kitty-" ""
        $w.session_is_active = $os_window.is_active | into bool
        $w.tab_is_active = $tab.is_active | into bool
        $w.win_is_active = $win.is_active | into bool
        $w.tab_id = $tab.id
        $w.tab_title = $tab.title
        $w
      }
      $tab_windows
    }
  }
  | flatten
  | flatten
  | where { not ($in.tab_is_active and $in.session_is_active and $in.win_is_active) }
  | select session tab_title win_title tab_is_active win_is_active session_is_active tab_id win_id
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
      $t.session_is_active = $os_window.is_active | into bool
      $t.tab_is_active = $tab.is_active | into bool
      $t.tab_is_focused = $tab.is_focused | into bool
      $t.tab_id = $tab.id
      $t.tab_title = $tab.title
      $t.active_window_id = $tab.windows | where is_active | get 0.id
      $t
    }
  }
  | flatten
  # | where { not ($in.tab_is_active and $in.session_is_active) }
  | select tab_id tab_title tab_is_active session session_is_active active_window_id
  # | flatten
}

export def "ky sessions" [] {
  kitty @ ls
  | from json
  | select wm_class is_active
  | each {|os_window|
    mut x = $os_window
    $x.session = $os_window.wm_class | str replace "kitty-" ""
    $x.session_is_active = $os_window.is_active | into bool
    $x
  }
  | flatten
  | where { not $in.session_is_active }
  | select session session_is_active
  # | flatten
}

export def "ky session ls" [] {
  ky sessions
}

# Source command for the `kitty-sessions` television channel.
# Emits one `<status>\t<name>` line per session. The channel's display
# template renders the glyph alongside the name, and the action
# templates use `string_pipeline` to extract just the name column.
export def "ky session ls-all" [
  --running-first (-r)  # Sort running sessions to the top
  --running-only (-R)  # Only list currently-running sessions
] {
  # Scope to the focused OS-window (the user's primary kitty), so the
  # scratch / quake OS-window's session doesn't appear as "running" here.
  # `session_name` lives on each kitty window (not the OS-window) and
  # is the session-file basename WITHOUT the `.kitty-session` suffix.
  let running = try {
    kitty @ ls
    | from json
    | where is_focused == true
    | get tabs | flatten
    | get windows | flatten
    | get session_name
    | compact
    | uniq
  } catch { [] }
  let rows = ls $sessions_dir
  | get name
  | each { path basename }
  | sort
  | each {|name|
    let stem = ($name | str replace --regex '\.kitty-session$' '')
    let is_running = ($stem in $running)
    let glyph = if $is_running { "●" } else { "○" }
    {is_running: $is_running, line: $"($glyph)\t($name)"}
  }
  let filtered = if $running_only {
    $rows | where is_running
  } else {
    $rows
  }
  let sorted = if $running_first {
    $filtered | sort-by --reverse is_running
  } else {
    $filtered
  }
  $sorted | get line | str join "\n"
}

# Preview helper for the `kitty-sessions` television channel.
# Shows running-status + session-file contents.
export def "ky session preview" [session_name: string@"_sessions_files"] {
  let session_path = $sessions_dir | path join $session_name
  let stem = ($session_name | str replace --regex '\.kitty-session$' '')
  let running = try {
    kitty @ ls
    | from json
    | where is_focused == true
    | get tabs | flatten
    | get windows | flatten
    | get session_name
    | compact
    | any { $in == $stem }
  } catch { false }
  let status = if $running { "● running" } else { "○ stopped" }
  print $"($status)  —  ($session_path)\n"
  ^bat --color=always --style=plain --language=sh $session_path
}

# Smart launch:
#   - When invoked from INSIDE kitty (e.g. tv running as an overlay),
#     reload the current OS-window in place via the `goto_session`
#     kitty action — same behavior as the `goto_session` keybinds in
#     kitty.conf. This handles the common "I'm already in kitty, swap
#     to a different session" case.
#   - When invoked from outside kitty, spawn a detached kitty for each
#     selected session.
#   - For multi-select inside kitty, the first selection takes over
#     the current OS-window; remaining selections spawn new ones.
export def "ky session launch" [...names: string@"_sessions_files"] {
  if ($names | is-empty) { return }
  let in_kitty = ($env.KITTY_PID? != null)
  for entry in ($names | enumerate) {
    let i = $entry.index
    let name = $entry.item
    let session_path = $sessions_dir | path join $name
    if (not ($session_path | path exists)) {
      print -e $"ky: session not found: ($name)"
      continue
    }
    if ($in_kitty and $i == 0) {
      kitty @ action goto_session $session_path
    } else {
      let kitty_name = $"kitty-($name)"
      (
        kitty
        --detach
        --single-instance
        --session $session_path
        --app-id $kitty_name
        --title $kitty_name
      )
    }
  }
}

# Open one or more session files in $EDITOR.
export def "ky session edit" [...names: string@"_sessions_files"] {
  let paths = $names | each {|n| $sessions_dir | path join $n }
  let editor = $env.EDITOR? | default "nvim"
  ^$editor ...$paths
}

# Close the windows belonging to the given session(s) within the
# currently focused kitty OS-window (the user's primary kitty, not
# the scratch / quake OS-window). Uses `close-window` rather than
# `close-tab` so that when tv is running as an overlay in a tab that
# also contains the closed session's window, the tv overlay survives
# (and so does its enclosing OS-window). Leaves session config files
# on disk untouched.
export def "ky session close" [...names: string@"_sessions_files"] {
  if ($names | is-empty) { return }
  # Gather windows in the focused OS-window once.
  let live_windows = try {
    kitty @ ls | from json
    | where is_focused == true
    | get tabs | flatten
    | get windows | flatten
  } catch { [] }
  # Compute (stem, count) for each requested session, dropping sessions
  # that have no live windows in the focused OS-window.
  let targets = $names | each {|name|
    let stem = ($name | str replace --regex '\.kitty-session$' '')
    let n = $live_windows | where session_name == $stem | length
    {stem: $stem, count: $n}
  } | where count > 0
  if ($targets | is-empty) { return }
  # Single confirmation prompt summarising all sessions that will be
  # affected. Matches the behaviour of kitty's built-in `close_session`
  # action, which prompts when there are active terminals.
  let summary = $targets
    | each {|t| $"($t.count) in '($t.stem)'" }
    | str join ", "
  let prompt = $"Close active windows: ($summary)?"
  let answer = kitten ask --type yesno --default n --message $prompt | complete
  let confirmed = $answer.exit_code == 0 and (
    ($answer.stdout | from json | get response?) == "y"
  )
  if not $confirmed { return }
  for t in $targets {
    do --ignore-errors {
      kitty @ close-window --match $"session:^($t.stem)$ and state:focused_os_window" err> /dev/null
    }
  }
}

export def "ky session start" [session_name: string@"_sessions_files"] {
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
