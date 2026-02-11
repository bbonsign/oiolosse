#!/usr/bin/env nu

def get_emoji [hour: int] {
  match $hour {
    $h if $h >= 9 and $h < 17 => "💻"
    $h if $h >= 17 and $h < 22 => "🏠"
    _ => "🌚"
  }
}

def format_tz [tz: string label: string] {
  let dt = (date now | date to-timezone $tz)
  let hour = ($dt | format date "%H" | into int)
  let formatted = ($dt | format date "%Y-%m-%d %H:%M")
  let ampm = ($dt | format date "%I:%M %p")
  $"($label):  ($formatted)  ($ampm)  (get_emoji $hour)"
}

def main [] {
  print ""
  print "  ╭───────────────────────────────────────────────────────────╮"
  print "  │                     🌍 World Clock 🌍                     │"
  print "  ╰───────────────────────────────────────────────────────────╯"
  print ""
  print $"  (format_tz 'America/New_York' 'Raleigh         (ET)')"
  print $"  (format_tz 'UTC' 'UTC            (UTC)')"
  print $"  (format_tz 'Europe/Berlin' 'Heilbronn (CET/CEST)')"
  print $"  (format_tz 'Asia/Dubai' 'Dubai          (GST)')"
  print $"  (format_tz 'Asia/Singapore' 'Singapore      (SGT)')"
  print ""
  print "  Press 'q' to quit"
}
