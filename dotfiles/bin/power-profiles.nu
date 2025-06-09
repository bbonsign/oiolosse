#!/bin/env nu

let options = [
  "  power-saver"
  "  balanced"
  "  performance"
]
let current_profile = powerprofilesctl get
let current_profile_index = $options | enumerate | where { $in.item like $current_profile } | get 0.index
let _choice = $options | str join "\n" | fuzzel --dmenu --lines 3 --select-index=($current_profile_index) --config ~/.config/fuzzel/power-profiles.ini --placeholder=$"current profile: ($current_profile)"

if ($_choice | is-not-empty) {
  let choice = $_choice | parse --regex '(.*)\s+(.*)'
  powerprofilesctl set ($choice.capture1.0 | str trim)
}
