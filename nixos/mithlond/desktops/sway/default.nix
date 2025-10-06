{ pkgs, ... }:

{
  config = {
    programs.sway = {
      enable = true;
      package = pkgs.swayfx;
      wrapperFeatures.gtk = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

    environment.systemPackages = with pkgs; [
      brightnessctl
      fuzzel
      # mako # notification system developed by swaywm maintainer
      networkmanagerapplet
      rofi
      sway
      swappy # screenshot annotation tool 
      sway-contrib.grimshot
      swaynotificationcenter
      slurp # screen selection functionality
      waybar
      wev # Wayland event viewer
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      wlprop # click to get window details
    ];
  };
}
