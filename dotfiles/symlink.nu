#!/usr/bin/env nu

# Script to create symlinks to all dotfiles

echo "===== Symlinking dotfiles ====="
let DOTFILES = $env.HOME | path join oiolosse dotfiles
let CONFIG_DIR = $env.HOME | path join .config
let SERVICE_DIR = $env.HOME | path join .config systemd user
let BIN_DIR = $env.HOME | path join .local bin
let VIMIUM_DIR = $env.HOME | path join code github.com philc vimium

^mkdir -p ($SERVICE_DIR | path join niri.service.wants)

def create_symlink [src dest] {
  if ($dest | path exists) or (($dest | path type) == "symlink") {
    trash put $dest
  }
  ln -sf ([$DOTFILES $src] | path join) $dest
}

# create_symlink "justfile" "$env.HOME/justfile"
create_symlink rsync_excludes ($env.HOME | path join rsync_excludes)
create_symlink dot_iex.exs ($env.HOME | path join .iex.exs)
# create_symlink ./ipython_config.py ($env.HOME | path join .ipython profile_default ipython_config.py)
create_symlink ./symlink.nu ($BIN_DIR | path join .f)

let bin_files = ls ($DOTFILES | path join bin)

$bin_files | each {|x|
  create_symlink $x.name ($BIN_DIR | path join ($x.name | path basename))
}

create_symlink ./direnv/direnvrc ([$CONFIG_DIR] | path join direnv direnvrc)
create_symlink ./dunst/ ($CONFIG_DIR | path join dunst)
# create_symlink dygma/  ($CONFIG_DIR  | path join dygma)
create_symlink ./eww ($CONFIG_DIR | path join eww)
create_symlink ./foot ($CONFIG_DIR | path join foot)
create_symlink ./fuzzel ($CONFIG_DIR | path join fuzzel)
# create_symlink ./ghostty ($CONFIG_DIR  | path join ghostty)
create_symlink ./hypr ($CONFIG_DIR | path join hypr)
create_symlink ./kitty ($CONFIG_DIR | path join kitty)
# create_symlink kanata ($CONFIG_DIR  | path join kanata)
create_symlink keyd ($CONFIG_DIR | path join keyd)
# create_symlink litecli ($CONFIG_DIR  | path join litecli)
create_symlink ./niri ($CONFIG_DIR | path join niri)
create_symlink ./nushell/autoload ($CONFIG_DIR | path join nushell autoload)
create_symlink ./nushell/scripts ($CONFIG_DIR | path join nushell scripts)
create_symlink ./nvim ($CONFIG_DIR | path join nvim)
create_symlink ./rofi ($CONFIG_DIR | path join rofi)
create_symlink ./sway ($CONFIG_DIR | path join sway)
# create_symlink  ($SERVICE_DIR | path join swayidle.service )
# ln -s ($SERVICE_DIR  | path join swayidle.service) ($SERVICE_DIR | path join niri.service.wants/ ) | complete
create_symlink ./swayidle ($CONFIG_DIR | path join swayidle)
# create_symlink ./swayidle/swayidle.service ($SERVICE_DIR | path join niri.service.wants/ )
create_symlink ./swaylock/ ($CONFIG_DIR | path join swaylock)
create_symlink ./television/ ($CONFIG_DIR | path join television)
# create_symlink tridactyl/ ($CONFIG_DIR  | path join tridactyl)
create_symlink ./waybar ($CONFIG_DIR | path join waybar)
create_symlink ./wlr-which-key ($CONFIG_DIR | path join wlr-which-key)
create_symlink ./libinput-gestures.conf ($CONFIG_DIR | path join libinput-gestures.conf)

create_symlink ./vimium/blank.html ($VIMIUM_DIR | path join pages blank.html)
create_symlink ../home-manager/bbonsign/modules/wallpapers/jackson-hendry-eodA_8CTOFo-unsplash.jpg ($VIMIUM_DIR | path join pages jackson-hendry-eodA_8CTOFo-unsplash.jpg)

print "===== Finished symlinking to dotfiles ====="
