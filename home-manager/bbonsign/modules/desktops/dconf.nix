# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

{
  config = with lib.hm.gvariant; {
    dconf.settings = {
      "org/gnome/desktop/background" = {
        color-shading-type = "solid";
        picture-options = "zoom";
        picture-uri =
          "file://${../wallpapers/stsci-h-p1821a-m-1699x2000.png}";
        picture-uri-dark =
          "file://${../wallpapers/stsci-h-p1821a-m-1699x2000.png}";
        primary-color = "#000000000000";
        secondary-color = "#000000000000";
      };

      "org/gnome/desktop/calendar" = { show-weekdate = true; };

      "org/gnome/desktop/input-sources" = {
        sources = [ (mkTuple [ "xkb" "us" ]) ];
        xkb-options = [ "terminate:ctrl_alt_bksp" "ctrl:nocaps" ];
      };

      "org/gnome/desktop/interface" = {
        cursor-size = 24;
        icon-theme = "Adwaita";
        cursor-theme = "Nordzy-cursors";
        clock-show-date = true;
        clock-show-seconds = false;
        clock-show-weekday = true;
        color-scheme = "prefer-dark";
        enable-hot-corners = false;
        gtk-key-theme = "Emacs";
        gtk-theme = "Adwaita";
        locate-pointer = false;
        show-battery-percentage = true;
      };

      "org/gnome/desktop/peripherals/keyboard" = {
        delay = mkUint32 260;
        repeat-interval = mkUint32 10;
      };

      "org/gnome/desktop/peripherals/mouse" = { natural-scroll = false; };

      "org/gnome/desktop/peripherals/touchpad" = {
        natural-scroll = false;
        tap-to-click = true;
        two-finger-scrolling-enabled = true;
      };

      "org/gnome/desktop/search-providers" = {
        disabled = [
          "org.gnome.Contacts.desktop"
          "org.gnome.Nautilus.desktop"
          "org.gnome.Calculator.desktop"
          "org.gnome.Calendar.desktop"
          "org.gnome.clocks.desktop"
          "org.gnome.Photos.desktop"
          "org.gnome.Epiphany.desktop"
        ];
        sort-order = [
          "org.gnome.Settings.desktop"
          "org.gnome.Documents.desktop"
          "org.gnome.seahorse.Application.desktop"
          "org.gnome.Nautilus.desktop"
          "org.gnome.Contacts.desktop"
          "org.gnome.Calculator.desktop"
          "org.gnome.Calendar.desktop"
          "org.gnome.Characters.desktop"
          "org.gnome.clocks.desktop"
          "org.gnome.Photos.desktop"
        ];
      };

      "org/gnome/desktop/sound" = {
        event-sounds = false;
        theme-name = "__custom";
      };

      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Shift><Super>q" ];
        maximize-horizontally = [ "<Super>j" ];
        maximize-vertically = [ "<Super>k" ];
        minimize = [ ];
        move-to-workspace-1 = [ "<Shift><Super>1" ];
        move-to-workspace-2 = [ "<Shift><Super>2" ];
        move-to-workspace-3 = [ "<Shift><Super>3" ];
        move-to-workspace-4 = [ "<Shift><Super>4" ];
        move-to-workspace-left = [ "<Shift><Super>bracketleft" ];
        move-to-workspace-right = [ "<Shift><Super>bracketright" ];
        switch-to-workspace-1 = [ "<Super>1" ];
        switch-to-workspace-2 = [ "<Super>2" ];
        switch-to-workspace-3 = [ "<Super>3" ];
        switch-to-workspace-4 = [ "<Super>4" ];
        switch-to-workspace-left = [ "<Super>bracketleft" ];
        switch-to-workspace-right = [ "<Super>bracketright" ];
        toggle-fullscreen = [ "<Super><Shift>f" ];
      };

      "org/gnome/desktop/wm/preferences" = {
        action-middle-click-titlebar = "menu";
        action-right-click-titlebar = "menu";
        button-layout = "appmenu:maximize,close";
        resize-with-right-button = false;
        workspace-names = [ ];
      };

      "org/gnome/desktop/a11y" = {
        always-show-universal-access-status = true;
      };

      "org/gnome/mutter" = {
        dynamic-workspaces = false;
        edge-tiling = true;
        workspaces-only-on-primary = true;
      };

      "org/gnome/mutter/keybindings" = {
        toggle-tiled-left = [ "<Super>h" ];
        toggle-tiled-right = [ "<Super>l" ];
      };

      "org/gnome/nautilus/icon-view" = { default-zoom-level = "small"; };

      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
        night-light-temperature = mkUint32 3200;
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
        screensaver = [ "<Shift><Super>l" ];
        www = [ "<Super>b" ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
        {
          binding = "<Super>Return";
          command = "/var/home/bbonsign/.local/bin/kitty";
          name = "terminal";
        };

      "org/gnome/settings-daemon/plugins/power" = {
        power-button-action = "nothing";
        sleep-inactive-ac-timeout = 1800;
        sleep-inactive-ac-type = "suspend";
        sleep-inactive-battery-timeout = 900;
        sleep-inactive-battery-type = "suspend";
      };

      "org/gnome/shell/extensions/auto-move-windows" = {
        application-list = [
          "kitty.desktop:1"
          "firefox.desktop:2"
          "slack.desktop:3"
          "Bazecor.desktop:4"
        ];
      };

      "org/gnome/shell/extensions/Logo-menu" = {
        menu-button-terminal = "/var/home/bbonsign/.local/bin/kitty";
      };

      "org/gnome/shell/keybindings" = {
        switch-to-application-1 = [ ];
        switch-to-application-2 = [ ];
        switch-to-application-3 = [ ];
        switch-to-application-4 = [ ];
        toggle-overview = [ "<Super>o" ];
      };

      "org/gnome/tweaks" = { show-extensions-notice = false; };

      # "org/gnome/shell/world-clocks" = {
      #   locations = [
      #     (mkVariant [
      #       (mkUint32 2)
      #       (mkVariant [
      #         "Sacramento"
      #         "KSAC"
      #         true
      #         [ (mkTuple [ 0.6720729576810752 (-2.1204877747105106) ]) ]
      #         [ (mkTuple [ 0.6733754619952538 (-2.1204773027349986) ]) ]
      #       ])
      #     ])
      #     (mkVariant [
      #       (mkUint32 2)
      #       (mkVariant [
      #         "Raleigh"
      #         "KRDU"
      #         true
      #         [ (mkTuple [ 0.6260593067210071 (-1.3750818938070426) ]) ]
      #         [ (mkTuple [ 0.6243408555394935 (-1.3725027509582006) ]) ]
      #       ])
      #     ])
      #     (mkVariant [
      #       (mkUint32 2)
      #       (mkVariant [
      #         "London"
      #         "EGWU"
      #         true
      #         [ (mkTuple [ 0.8997172294030767 (-7.272211034407213e-3) ]) ]
      #         [ (mkTuple [ 0.8988445647770796 (-2.0362232784242244e-3) ]) ]
      #       ])
      #     ])
      #     (mkVariant [
      #       (mkUint32 2)
      #       (mkVariant [
      #         "Berlin"
      #         "EDDT"
      #         true
      #         [ (mkTuple [ 0.9174614159494501 0.23241968454167572 ]) ]
      #         [ (mkTuple [ 0.916588751323453 0.23387411976724018 ]) ]
      #       ])
      #     ])
      #   ];
      # };

      # "org/gnome/clocks" = {
      #   world-clocks = [
      #     {
      #       location = mkVariant [
      #         (mkUint32 2)
      #         (mkVariant [
      #           "Sacramento"
      #           "KSAC"
      #           true
      #           [ (mkTuple [ 0.6720729576810752 (-2.1204877747105106) ]) ]
      #           [ (mkTuple [ 0.6733754619952538 (-2.1204773027349986) ]) ]
      #         ])
      #       ];
      #     }
      #     {
      #       location = mkVariant [
      #         (mkUint32 2)
      #         (mkVariant [
      #           "Raleigh"
      #           "KRDU"
      #           true
      #           [ (mkTuple [ 0.6260593067210071 (-1.3750818938070426) ]) ]
      #           [ (mkTuple [ 0.6243408555394935 (-1.3725027509582006) ]) ]
      #         ])
      #       ];
      #     }
      #     {
      #       location = mkVariant [
      #         (mkUint32 2)
      #         (mkVariant [
      #           "London"
      #           "EGWU"
      #           true
      #           [ (mkTuple [ 0.8997172294030767 (-7.272211034407213e-3) ]) ]
      #           [ (mkTuple [ 0.8988445647770796 (-2.0362232784242244e-3) ]) ]
      #         ])
      #       ];
      #     }
      #     {
      #       location = mkVariant [
      #         (mkUint32 2)
      #         (mkVariant [
      #           "Berlin"
      #           "EDDT"
      #           true
      #           [ (mkTuple [ 0.9174614159494501 0.23241968454167572 ]) ]
      #           [ (mkTuple [ 0.916588751323453 0.23387411976724018 ]) ]
      #         ])
      #       ];
      #     }
      #   ];
      # };

    };
  };
}
