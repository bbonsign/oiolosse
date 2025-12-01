{ pkgs, lib, inputs, ... }:
{
  imports = [
    ../dms
  ];

  config = {
    home.packages = with pkgs; [
      fuzzel
      networkmanager_dmenu
      polkit_gnome
      power-profiles-daemon
      rofi
      soteria # polkit agent
      swappy # screenshot annotation tool
      swaybg
      # swayidle
      # swaynotificationcenter
      wev
      wl-clipboard
      wlprop
      wlr-which-key
      wmenu
      xwayland-satellite
    ];

    # handled by DMS
    programs = {
      waybar = {
        enable = false;
        systemd = {
          enable = false;
          target = "niri.service";
        };
      };
    };

    services.hypridle = {
      enable = true;
      systemdTarget = "graphical-session.target";
    };

    systemd.user = {
      services = {

        polkit-soteria = {
          Install.WantedBy = [ "graphical-session.target" ];
          Unit = {
            Description = "Soteria, Polkit authentication agent for any desktop environment";
            Wants = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };
          Service = {
            Type = "simple";
            ExecStart = "${pkgs.soteria}/bin/soteria";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };

        # swayidle = {
        #   Install.WantedBy = [ "niri.service" ];
        #   Unit = {
        #     After = [ "niri.service" ];
        #     PartOf = [ "graphical-session.target" ];
        #     Requisite = [ "graphical-session.target" ];
        #   };
        #   Service = {
        #     Type = "simple";
        #     Restart = lib.mkForce "on-failure";
        #     ExecStart = "${pkgs.swayidle}/bin/swayidle";
        #   };
        # };


        # handled by DMS
        # swaybg = {
        #   Install.WantedBy = [ "niri.service" ];
        #   Unit = {
        #     After = [ "graphical-session.target" ];
        #     PartOf = [ "graphical-session.target" ];
        #     Requisite = [ "graphical-session.target" ];
        #   };
        #   Service = {
        #     Restart = lib.mkForce "on-failure";
        #     # ExecStart = "${pkgs.swaybg}/bin/swaybg --image %h/oiolosse/home-manager/bbonsign/modules/wallpapers/stsci-h-p1821a-m-1699x2000.png --mode fill";
        #     ExecStart = "${pkgs.swaybg}/bin/swaybg --image %h/oiolosse/home-manager/bbonsign/modules/wallpapers/phil-botha-a0TJ3hy-UD8-unsplash.jpg --mode fill";
        #   };
        # };

        # handled by DMS
        # swaync = {
        #   Install.WantedBy = [ "niri.service" ];
        #   Unit = {
        #     After = [ "graphical-session.target" ];
        #     PartOf = [ "graphical-session.target" ];
        #     Requisite = [ "graphical-session.target" ];
        #   };
        #   Service = {
        #     Restart = lib.mkForce "on-failure";
        #     ExecStart = "${pkgs.swaynotificationcenter}/bin/swaync";
        #   };
        # };

      };
    };
  };
}
