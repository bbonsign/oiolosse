{ pkgs, ... }:

{
  config = {
    # Optional, hint electron apps to use wayland:
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.systemPackages = with pkgs; [
      # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      niri
      xwayland-satellite
      fuzzel
      grim # screenshot functionality
      hyprpicker
      swaynotificationcenter
      rofi-wayland
      waybar
      swaybg
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    ];
  };
}
