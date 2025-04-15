{ pkgs, lib, ... }:
{
  config = {
    home.packages = with pkgs; [
      fuzzel
      rofi-wayland
      swaybg
      swayidle
      swaynotificationcenter
      waybar
      wev
      wl-clipboard
      wlprop
      wlr-which-key
      wmenu
      xwayland-satellite
    ];

    systemd.user.services = {
      swayidle = {
        Install.WantedBy = [ "niri.service" ];
        Unit = {
          After = [ "niri.service" ];
          PartOf = [ "graphical-session.target" ];
          Requisite = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          Restart = lib.mkForce "on-failure";
          ExecStart = "${pkgs.swayidle}/bin/swayidle";
        };
      };

    };
  };
}
