{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      fuzzel
      rofi
      slurp # screen selection functionality
      swappy # screenshot annotation tool
      sway-contrib.grimshot
      swaybg
      swayidle
      swaynotificationcenter
      waybar
      wev
      wl-clipboard
      wlprop
      wlr-which-key
      wmenu

    ];
  };
}
