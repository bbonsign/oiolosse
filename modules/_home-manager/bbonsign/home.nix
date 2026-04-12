{ inputs, pkgs, lib, isNixOS, ... }:

{
  imports = [
    ./modules
  ] ++ lib.optionals (!isNixOS) [
    {
      nixpkgs.overlays = [
        inputs.neovim-nightly-overlay.overlays.default
      ];
      nixpkgs.config = {
        allowUnfree = true;
        allowUnfreePredicate = _pkg: true;
      };
    }
  ];

  config = {
    home.sessionVariables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "kitty";
      GRIM_DEFAULT_DIR = "$HOME/Pictures/Screenshots";
      ERL_AFLAGS = "-kernel shell_history enabled";
      # Hint electron apps to use wayland:
      NIXOS_OZONE_WL = "1";
    };

    # nix = {
    #   package = pkgs.nixVersions.stable;
    #   extraOptions = ''
    #     experimental-features = nix-command flakes pipe-operators
    #   '';
    # };


    home.shellAliases = import ./modules/programs/shellAliases.nix;



    services = {
      ssh-agent.enable = true;
      # https://nixos.wiki/wiki/Bluetooth#Using_Bluetooth_headset_buttons_to_control_media_player
      mpris-proxy.enable = true;
      gnome-keyring.enable = true;
    };

    xdg.terminal-exec = {
      enable = true;
      settings = {
        # GNOME = [
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
}
