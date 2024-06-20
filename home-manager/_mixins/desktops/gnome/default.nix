{ pkgs, ... }:

{
  imports = [ ./dconf.nix ];

  config = {
    home.packages = with pkgs; [
      gnome.gnome-tweaks
      gnome.gnome-themes-extra
      # gnomeExtensions.hide-top-bar
      # gnomeExtensions.valent
    ];
  };
}
