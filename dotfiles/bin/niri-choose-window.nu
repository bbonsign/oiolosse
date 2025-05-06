#!/usr/bin/env nu

def zero-pad [id] {
  if (($id | into int) < 10) {
    $"0($id)"
  } else {
    $id
  }
}

def trim-title [title] {
  let cutoff = 25
  let len = $title | str length
  if ($len) > $cutoff {
    [($title | str substring 0..$cutoff) "..."] | str join
  } else {
    [$title (1..($cutoff + 4 - $len) | each { " " } | str join)] | str join
  }
}

let window = niri msg --json windows | from json | each { $"(zero-pad $in.id): (trim-title $in.title)  ($in.app_id)" } | to text | fuzzel --prompt " " --dmenu --width 100 | parse '{id}: {title}  {app_id}' | get 0

niri msg action focus-window --id $window.id
