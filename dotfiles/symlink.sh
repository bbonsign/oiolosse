#!/usr/bin/env bash

# Script to create symlinks to all dotfiles

echo "===== Symlinking dotfiles ====="
DOTFILES="$HOME/oiolosse/dotfiles"
CONFIG_DIR="$HOME/.config"
SERVICE_DIR="$HOME/.config/systemd/user"
BIN_DIR="$HOME/.local/bin"

mkdir -p "$SERVICE_DIR/niri.service.wants"

create_symlink() {
  local src="$1"
  local dest="$2"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    trash put "$dest"
  fi
  ln -sf "${DOTFILES}/${src}" "${dest}"
}

# create_symlink "justfile" "$HOME/justfile"
create_symlink rsync_excludes "$HOME/rsync_excludes"

create_symlink ./symlink.sh "$BIN_DIR/.f"
create_symlink ./bin/niri-windows.nu "$BIN_DIR/niri-windows.nu"
create_symlink ./bin/appimage_setup.sh "$BIN_DIR/appimage_setup.sh"

create_symlink ./direnv/direnvrc "$CONFIG_DIR/direnv/direnvrc"
create_symlink ./dunst/ "$CONFIG_DIR/dunst"
# create_symlink dygma/               "$CONFIG_DIR/dygma"
create_symlink ./foot "$CONFIG_DIR/foot"
create_symlink ./fuzzel "$CONFIG_DIR/fuzzel"
# create_symlink ./ghostty "$CONFIG_DIR/ghostty"
create_symlink ./kitty "$CONFIG_DIR/kitty"
# create_symlink kanata "$CONFIG_DIR/kanata"
# create_symlink keyd "$CONFIG_DIR/keyd"
# create_symlink litecli "$CONFIG_DIR/litecli"
create_symlink ./niri "$CONFIG_DIR/niri"
create_symlink ./nushell/scripts "$CONFIG_DIR/nushell/scripts"
create_symlink ./nvim "$CONFIG_DIR/nvim"
create_symlink ./rofi "$CONFIG_DIR/rofi"
create_symlink ./sway "$CONFIG_DIR/sway"
create_symlink ./swayidle/swayidle.service "$SERVICE_DIR/swayidle.service"
create_symlink ./swayidle "$CONFIG_DIR/swayidle"
ln -s "$SERVICE_DIR/swayidle.service" "$SERVICE_DIR/niri.service.wants/"
create_symlink ./swaylock/ "$CONFIG_DIR/swaylock"
create_symlink ./television/ "$CONFIG_DIR/television"
# create_symlink tridactyl/ "$CONFIG_DIR/tridactyl"
create_symlink ./waybar "$CONFIG_DIR/waybar"
create_symlink ./wlr-which-key "$CONFIG_DIR/wlr-which-key"
create_symlink ./libinput-gestures.conf "$CONFIG_DIR/libinput-gestures.conf"

echo "===== Finished symlinking to dotfiles ====="
