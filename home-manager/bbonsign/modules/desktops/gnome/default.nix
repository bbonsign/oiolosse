{ pkgs, ... }:

{
  imports = [ ./dconf.nix ];

  config = {
    home.packages = with pkgs; [
      gnome-tweaks
      gnome-themes-extra
      # gnomeExtensions.hide-top-bar
      # gnomeExtensions.valent
    ];
  };
}
