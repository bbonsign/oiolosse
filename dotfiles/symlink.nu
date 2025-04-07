#!/usr/bin/env nu

# Script to create symlinks to all dotfiles

echo "===== Symlinking dotfiles ====="
let DOTFILES = [$env.HOME "oiolosse" "dotfiles"] | path join
let CONFIG_DIR = [$env.HOME ".config"] | path join
let SERVICE_DIR = [$env.HOME ".config" "systemd" "user"] | path join
let BIN_DIR = [$env.HOME ".local" "bin"] | path join

^mkdir -p ([$SERVICE_DIR "niri.service.wants"] | path join)

def create_symlink [src dest] {
  if ($dest | path exists) or (($dest | path type) == "symlink") {
    trash put $dest
  }
  ln -sf ([$DOTFILES $src] | path join) $dest
}

# create_symlink "justfile" "$env.HOME/justfile"
create_symlink ./rsync_excludes ([$env.HOME rsync_excludes] | path join)
create_symlink ./dot_iex.exs ([$env.HOME ".iex.exs"] | path join)
create_symlink ./ipython_config.py ([$env.HOME ".ipython" "profile_default" "ipython_config.py"] | path join)
create_symlink ./symlink.nu ([$BIN_DIR .f] | path join)

let bin_files = ls ($DOTFILES | path join "bin")

$bin_files | each {
  create_symlink $in.name ([$BIN_DIR ($in.name | path basename)] | path join)
}

create_symlink ./direnv/direnvrc ([$CONFIG_DIR "direnv/direnvrc"] | path join)
create_symlink ./dunst/ ([$CONFIG_DIR "dunst"] | path join)
# create_symlink dygma/  ([$CONFIG_DIR "dygma"] | path join)
create_symlink ./foot ([$CONFIG_DIR "foot"] | path join)
create_symlink ./fuzzel ([$CONFIG_DIR "fuzzel"] | path join)
# create_symlink ./ghostty ([$CONFIG_DIR "ghostty"] | path join)
create_symlink ./hypr ([$CONFIG_DIR "hypr"] | path join)
create_symlink ./kitty ([$CONFIG_DIR "kitty"] | path join)
# create_symlink kanata ([$CONFIG_DIR "kanata"] | path join)
# create_symlink keyd ([$CONFIG_DIR "keyd"] | path join)
# create_symlink litecli ([$CONFIG_DIR "litecli"] | path join)
create_symlink ./niri ([$CONFIG_DIR "niri"] | path join)
create_symlink ./nushell/scripts ([$CONFIG_DIR "nushell/scripts"] | path join)
create_symlink ./nvim ([$CONFIG_DIR "nvim"] | path join)
create_symlink ./rofi ([$CONFIG_DIR "rofi"] | path join)
create_symlink ./sway ([$CONFIG_DIR "sway"] | path join)
# create_symlink  ([$SERVICE_DIR "swayidle.service"] | path join)
# ln -s ([$SERVICE_DIR swayidle.service] | path join) ([$SERVICE_DIR niri.service.wants/] | path join) | complete 
create_symlink ./swayidle ([$CONFIG_DIR "swayidle"] | path join)
# create_symlink ./swayidle/swayidle.service ([$SERVICE_DIR niri.service.wants/] | path join)
create_symlink ./swaylock/ ([$CONFIG_DIR "swaylock"] | path join)
create_symlink ./television/ ([$CONFIG_DIR "television"] | path join)
# create_symlink tridactyl/ ([$CONFIG_DIR "tridactyl"] | path join)
create_symlink ./waybar ([$CONFIG_DIR "waybar"] | path join)
create_symlink ./wlr-which-key ([$CONFIG_DIR "wlr-which-key"] | path join)
create_symlink ./libinput-gestures.conf ([$CONFIG_DIR "libinput-gestures.conf"] | path join)

print "===== Finished symlinking to dotfiles ====="
