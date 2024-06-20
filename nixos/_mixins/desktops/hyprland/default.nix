{ pkgs, ... }:

{
  config = {
    programs.hyprland = { enable = true; };
    # Optional, hint electron apps to use wayland:
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.systemPackages = with pkgs; [
      # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      grim # screenshot functionality
      mako # notification system developed by swaywm maintainer
      rofi-wayland
      slurp # screenshot functionality
      waybar
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    ];
  };
}
