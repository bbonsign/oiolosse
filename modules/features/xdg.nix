_: {
  flake.homeModules.xdg = {pkgs, ...}: {

    config = {
      xdg.terminal-exec = {
        enable = true;
        settings = {
          # GNOME = i
          #   "com.raggesilver.BlackBox.desktop"
          #   "org.gnome.Terminal.desktop"
          # ];
          default = [
            "kitty.desktop"
          ];
        };
      };

      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-gnome
          pkgs.xdg-desktop-portal-termfilechooser
        ];
        config.common = {
          default = [ "gnome" "gtk" ];
          "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
        };
      };

      systemd.user.services.xdg-desktop-portal-termfilechooser = {
        Unit = {
          Description = "Portal service (terminal file chooser implementation)";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          Type = "dbus";
          BusName = "org.freedesktop.impl.portal.desktop.termfilechooser";
          ExecStart = "${pkgs.xdg-desktop-portal-termfilechooser}/libexec/xdg-desktop-portal-termfilechooser";
          Restart = "on-failure";
          Slice = "session.slice";
        };
      };

      xdg.configFile."xdg-desktop-portal-termfilechooser/config" = {
        force = true;
        text = ''
        [filechooser]
        cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
        default_dir=$HOME
        env=TERMCMD='/var/home/bbonsign/.local/bin/kitty --title "termfilechooser"'
        open_mode=suggested
        save_mode=last
        '';
      };
    };

  };
}

