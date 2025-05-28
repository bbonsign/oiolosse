#!/bin/env nu

let options = [
  "  power-saver"
  "  balanced"
  "  performance"
]
let _choice = $options | str join "\n" | fuzzel --dmenu --lines 3 --config ~/.config/fuzzel/power-profiles.ini

if ($_choice | is-not-empty) {
  let choice = $_choice | parse --regex '(.*)\s+(.*)'
  powerprofilesctl set ($choice.capture1.0 | str trim)
}
