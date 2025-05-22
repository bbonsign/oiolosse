{ pkgs, lib, ... }:
{
  config = {
    home.packages = with pkgs; [
      fuzzel
      libsForQt5.polkit-kde-agent
      # kdePackages.qtwayland
      rofi-wayland
      swappy # screenshot annotation tool
      swaybg
      swayidle
      swaynotificationcenter
      wev
      wl-clipboard
      wlprop
      wlr-which-key
      wmenu
      xwayland-satellite
    ];

    programs = {
      waybar = {
        enable = true;
        systemd = {
          enable = true;
          target = "niri.service";
        };
      };
    };

    systemd.user = {
      services = {
        # niri-flake-polkit = {
        #   Install.WantedBy = [ "niri.service" ];
        #   Unit = {
        #     Description = "PolicyKit Authentication Agent";
        #     After = [ "graphical-session.target" ];
        #     PartOf = [ "graphical-session.target" ];
        #   };
        #   Service = {
        #     Type = "simple";
        #     ExecStart = "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
        #     Restart = "on-failure";
        #     RestartSec = 1;
        #     TimeoutStopSec = 10;
        #   };
        # };
        swaybg = {
          Install.WantedBy = [ "niri.service" ];
          Unit = {
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
            Requisite = [ "graphical-session.target" ];
          };
          Service = {
            Restart = lib.mkForce "on-failure";
            ExecStart = "${pkgs.swaybg}/bin/swaybg --image %h/oiolosse/home-manager/bbonsign/modules/wallpapers/stsci-h-p1821a-m-1699x2000.png --mode fill";
          };
        };
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
  };
}
