#!/usr/bin/env nu

# @vicinae.schemaVersion 1
# @vicinae.title Open Work Apps
# @vicinae.description Launch Vivaldi, Fastmail, Slack PWA and Outlook PWA (idempotent)
# @vicinae.mode silent
# @vicinae.icon 💼

# Open Vivaldi, Fastmail (flatpak), and the Slack + Outlook PWAs (via Vivaldi).
# "Already open" is determined by querying Niri's window list, so an app only
# counts as running when it actually has a visible window.

const SLACK_APP_ID   = "hiibkplfjkckmmdmpiojdobionnfppbm"   # MH-TE - Slack
const OUTLOOK_APP_ID = "faolnafnngnfdaknnbpnkhgohbobgegn"   # Outlook

# Snapshot of Niri's current windows: list of records with `app_id`, `title`, …
let windows = (^niri msg --json windows | from json)

def has-window [app_id: string] {
    ($windows | where app_id == $app_id | is-not-empty)
}

# Launch a command fully detached (stdin/stdout/stderr off the tty) unless
# `already_running` is true.
def spawn-if-missing [name: string, already_running: bool, ...cmd: string] {
    if $already_running {
        print $"($name) already open, skipping"
        return
    }
    print $"launching ($name)..."
    open /dev/null | ^setsid -f ...$cmd out> /dev/null err> /dev/null
}

# 1. Vivaldi (main browser window)
spawn-if-missing "Vivaldi" (has-window "vivaldi-stable") "vivaldi"

# 2. Fastmail (flatpak)
spawn-if-missing "Fastmail" (has-window "com.fastmail.Fastmail") "flatpak" "run" "com.fastmail.Fastmail"

# 3. Slack PWA (installed from Vivaldi)
spawn-if-missing "Slack" (has-window $"vivaldi-($SLACK_APP_ID)-Default") "vivaldi" "--profile-directory=Default" $"--app-id=($SLACK_APP_ID)"

# 4. Outlook PWA (installed from Vivaldi)
spawn-if-missing "Outlook" (has-window $"vivaldi-($OUTLOOK_APP_ID)-Default") "vivaldi" "--profile-directory=Default" $"--app-id=($OUTLOOK_APP_ID)"

print "done."
