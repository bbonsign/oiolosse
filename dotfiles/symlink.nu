#!/usr/bin/env nu

# Symlink repository-managed dotfiles into their expected home directories.
# Existing files are preserved, correct links are left unchanged, and missing
# sources are reported without stopping the rest of the setup.

echo "===== Symlinking dotfiles ====="
let DOTFILES = $env.FILE_PWD
let CONFIG_DIR = [$env.HOME ".config"] | path join
let WALLPAPER_DIR = [$env.HOME "Pictures" "wallpapers"] | path join
let BIN_DIR = [$env.HOME ".local" bin] | path join
let DESKTOP_DIR = [$env.HOME ".local" "share" "applications"] | path join
let VIMIUM_DIR = [$env.HOME "code" "philc" "vimium"] | path join

# Create a symlink from `dest` to `src` without overwriting non-symlink paths.
# Relative sources are resolved from the directory containing this script.
def create_symlink [src dest] {
  let source = if ($src | str starts-with "/") {
    $src | path expand
  } else {
    [$DOTFILES $src] | path join | path expand
  }

  if not ($source | path exists) {
    print --stderr $"Skipping missing source: ($source)"
    return
  }

  let destination_type = try {
    $dest | path type
  } catch {
    null
  }

  if $destination_type == "symlink" {
    let current_source = ^readlink -- $dest | str trim
    if $current_source == $source {
      return
    }

    rm $dest
  } else if $destination_type != null {
    print --stderr $"Skipping existing destination: ($dest)"
    return
  }

  mkdir ($dest | path dirname)
  ln -s $source $dest
}

# Symlink each immediate child of `source_dir` into `destination_dir`.
# A missing source directory is reported and otherwise ignored.
def link_directory_files [source_dir destination_dir] {
  if ($source_dir | path exists) {
    ls $source_dir | each {|file|
      create_symlink $file.name ($destination_dir | path join ($file.name | path basename))
    }
  } else {
    print --stderr $"Skipping missing directory: ($source_dir)"
  }
}

# Paths linked to XDG_CONFIG directory
let config_paths = [
  "carapace"
  "direnv/direnvrc"
  "diffnav"
  "dunst"
  # "dygma"
  "foot"
  "fuzzel"
  # "ghostty"
  "hypr"
  "jj"
  "jjui"
  "kitty"
  # "kanata"
  "keyd"
  # "litecli"
  "mimeapps.list"
  "mise"
  "networkmanager-dmenu"
  "niri"
  "noctalia"
  "nushell/autoload"
  "nushell/scripts"
  "presenterm"
  "nom"
  "nvim_lazy"
  "nvim"
  "rofi"
  "soteria"
  # "starship.toml"
  "sway"
  "swayidle"
  "swaylock"
  "swaync"
  "television"
  # "tridactyl"
  "vicinae"
  "waybar"
  "wlr-which-key"
  "yazi"
  "libinput-gestures.conf"
]

$config_paths | each {|path|
  create_symlink $path ($CONFIG_DIR | path join $path)
}

let links = [
  # {source: "justfile", destination: ($env.HOME | path join justfile)}
  # {source: "ipython_config.py", destination: ($env.HOME | path join .ipython profile_default ipython_config.py)}
  {source: "rsync_excludes" destination: ($env.HOME | path join rsync_excludes)}
  {source: "dot_iex.exs" destination: ($env.HOME | path join .iex.exs)}
  {source: "symlink.nu" destination: ($BIN_DIR | path join .f)}
  {source: "nushell/tv.nu" destination: ($env.HOME | path join .local share nushell vendor autoload tv.nu)}
  {source: "vimium/blank.html" destination: ($VIMIUM_DIR | path join pages blank.html)}
  {
    source: ($WALLPAPER_DIR | path join jackson-hendry-eodA_8CTOFo-unsplash.jpg)
    destination: ($VIMIUM_DIR | path join pages jackson-hendry-eodA_8CTOFo-unsplash.jpg)
  }
  {
    source: ($WALLPAPER_DIR | path join phil-botha-a0TJ3hy-UD8-unsplash.jpg)
    destination: ($VIMIUM_DIR | path join pages phil-botha-a0TJ3hy-UD8-unsplash.jpg)
  }
]

$links | each {|link| create_symlink $link.source $link.destination }

link_directory_files ($DOTFILES | path join bin) $BIN_DIR
link_directory_files ($DOTFILES | path join desktop) $DESKTOP_DIR

print "===== Finished symlinking to dotfiles ====="
