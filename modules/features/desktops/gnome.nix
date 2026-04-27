_:
{
  flake.homeModules.gnome = {pkgs, ...}:
    {
      config = {
        home.packages = with pkgs; [
          gnome-tweaks
          gnome-themes-extra
          # gnomeExtensions.hide-top-bar
          # gnomeExtensions.valent
        ];
      };
    };

  flake.nixosModules.gnome = {pkgs, ...}:
    {
      config = {
        environment = {
          gnome.excludePackages = with pkgs; [
            baobab
            gnome-system-monitor
            epiphany
          ];

          systemPackages = with pkgs; [
            eyedropper
            gnome-tweaks
            gnomeExtensions.appindicator
            # gnomeExtensions.dash-to-dock
            gnomeExtensions.removable-drive-menu
            # gnomeExtensions.emoji-copy
            # gnomeExtensions.just-perfection
            gnomeExtensions.windownavigator
            # gnomeExtensions.workspace-switcher-manager
          ];
        };

        programs = {
          evince.enable = true; # document viewer
          file-roller.enable = true;
          geary.enable = false;
          gnome-disks.enable = true;
          gnome-terminal.enable = true;
          seahorse.enable = true;
        };

        qt = {
          enable = true;
          platformTheme = "gnome";
          style = "adwaita-dark";
        };

        services = {
          gnome = {
            games.enable = false;
            # gnome-browser-connector.enable = isInstall;
            # gnome-online-accounts.enable = isInstall;
            # tracker.enable = true;
            # tracker-miners.enable = true;
            gnome-keyring.enable = true;
          };
          # udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
          xserver = {
            enable = true;
            displayManager = {
              gdm = {
                enable = true;
                # autoSuspend = false;
              };
            };
            desktopManager.gnome.enable = true;
          };
        };

        xdg.portal = {
          config = {
            gnome = {
              default = [ "gnome" "gtk" ];
              "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
            };
          };
        };
      };
    };
}
