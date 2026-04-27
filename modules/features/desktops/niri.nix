
{inputs, ...}:
{
  flake.homeModules.niri = {pkgs,...}: {
    config = {
      home.packages = [
        pkgs.fuzzel
        pkgs.networkmanager_dmenu
        pkgs.polkit_gnome
        pkgs.power-profiles-daemon
        pkgs.rofi
        pkgs.soteria # polkit agent
        pkgs.swappy # screenshot annotation tool
        pkgs.swaybg
        # pkgs.swayidle
        # pkgs.swaynotificationcenter
        pkgs.wev
        pkgs.wl-clipboard
        pkgs.wlprop
        pkgs.wlr-which-key
        pkgs.wmenu
        pkgs.xwayland-satellite
      ];

      # handled by Shell
      programs = {
        waybar = {
          enable = false;
          systemd = {
            enable = false;
            targets = [ "niri.service" ];
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

          xdg-desktop-portal-gnome = {
            Install.WantedBy = [ "niri.service" ];
            Unit = {
              Description = "Portal service (GNOME implementation)";
              PartOf = [ "graphical-session.target" ];
              After = [ "graphical-session.target" ];
              Requisite = [ "graphical-session.target" ];
            };
            Service = {
              Type = "dbus";
              BusName = "org.freedesktop.impl.portal.desktop.gnome";
              ExecStart = "%h/.nix-profile/libexec/xdg-desktop-portal-gnome";
              Restart = "on-failure";
            };
          };

          # TODO: move to separate module
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


          # handled by Shell
          # swaybg = {
          #   Install.WantedBy = [ "niri.service" ];
          #   Unit = {
          #     After = [ "graphical-session.target" ];
          #     PartOf = [ "graphical-session.target" ];
          #     Requisite = [ "graphical-session.target" ];
          #   };
          #   Service = {
          #     Restart = lib.mkForce "on-failure";
          #     # ExecStart = "${pkgs.swaybg}/bin/swaybg --image %h/Pictures/wallpapers/stsci-h-p1821a-m-1699x2000.png --mode fill";
          #     ExecStart = "${pkgs.swaybg}/bin/swaybg --image %h/Pictures/wallpapers/phil-botha-a0TJ3hy-UD8-unsplash.jpg --mode fill";
          #   };
          # };

          # handled by Shell
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

  };

  flake.nixosModules.niri = {pkgs,...}: {
    config = {
      # Optional, hint electron apps to use wayland:
      environment.sessionVariables.NIXOS_OZONE_WL = "1";
      environment.systemPackages = [
        # niri
        inputs.niri.packages.x86_64-linux.niri
        pkgs.xwayland-satellite
        pkgs.fuzzel
        pkgs.grim # screenshot functionality
        pkgs.hyprpicker
        pkgs.swaynotificationcenter
        pkgs.rofi
        pkgs.waybar
        pkgs.swaybg
        pkgs.wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      ];
    };

  };
}
