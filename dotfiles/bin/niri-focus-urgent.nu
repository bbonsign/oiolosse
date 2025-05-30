#!/usr/bin/env nu


export def main [] {
  let urgent_windows = niri msg --json windows | from json | where is_urgent
  if ($urgent_windows | is-not-empty) {
    niri msg action focus-window --id ($urgent_windows | get 0.id)
  }
}
