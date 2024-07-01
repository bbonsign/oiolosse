{ pkgs, ... }:

{
  config = {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

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
