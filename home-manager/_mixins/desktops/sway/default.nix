{ lib, pkgs, config, ... }:

{
  # imports = [ ./git.nix ./common.nix ./dunst.nix ];

  config = {
    home.packages = with pkgs; [ ];

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_USE_XINPUT2 = "1";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "sway";
      # XKB_DEFAULT_OPTIONS =
      #   "terminate:ctrl_alt_bksp,caps:escape,altwin:swap_alt_win";
      SDL_VIDEODRIVER = "wayland";

      # needs qt5.qtwayland in systemPackages
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      _JAVA_AWT_WM_NONREPARENTING = 1;

      # gtk applications on wayland
      # export GDK_BACKEND=wayland
    };

    wayland.windowManager.sway = {
      enable = true;

      # extraSessionCommands = ''
      #   unset __NIXOS_SET_ENVIRONMENT_DONE
      # '';

      extraConfig = ''
        output * bg ${../../wallpapers/stsci-h-p1821a-m-1699x2000.png} fill

        # swaymsg -t get_inputs | jq -r '.[].identifier' | rg -S touch
        exec_always swaymsg input type:touchpad {
          dwt              enabled
          tap              enabled
          natural_scroll   disabled
          middle_emulation enabled
        }

        # exec_always for firefox crashing on config reload
        # https://bugzilla.mozilla.org/show_bug.cgi?id=1652820#c51
        exec_always swaymsg input type:keyboard {
          repeat_delay 210
          repeat_rate  90
          xkb_options ctrl:nocaps
        }
      '';
      config = {
        modifier = "Mod4";
        floating.modifier = "Mod4";
        terminal = "${pkgs.kitty}/bin/kitty}";
        menu = "${pkgs.rofi}/bin/rofi -show drun";
        # startup = [
        #   {
        #     command = "systemctl --user restart waybar";
        #     always = true;
        #   }
        #   { command = "dropbox start"; }
        #   { command = "firefox"; }
        # ];
        # floating.border = 0;
        # window.border = 0;
        # focus.forceWrapping = false;
        # focus.followMouse = false;
        # fonts = {
        #   names = [ "RobotoMono" ];
        #   size = 9.0;
        # };

        modes.resize = {
          Escape = "mode default";
          Return = "mode default";
          h = "resize shrink width 10 px or 10 ppt";
          j = "resize grow height 10 px or 10 ppt";
          k = "resize shrink height 10 px or 10 ppt";
          l = "resize grow width 10 px or 10 ppt";
          # Ditto, with arrow keys
          Left = "resize shrink width 10 px or 10 ppt";
          Down = "resize grow height 10 px or 10 ppt";
          Up = "resize shrink height 10 px or 10 ppt";
          Right = "resize grow width 10 px or 10 ppt";
        };

        # https://home-manager-options.extranix.com/?query=sway+keyb&release=master
        # mkOptionDefault extends default sway bindings instead of having to specify all of them
        keybindings = lib.mkOptionDefault
          (import ./sway-bindings.nix { inherit pkgs config; });

        # bars = mkForce [ ];
        # bars = [{ "command" = "${waybar}/bin/waybar"; }];

        # colors.focused = {
        #   border = bg-color;
        #   childBorder = bg-color;
        #   background = bg-color;
        #   text = text-color;
        #   indicator = "#00ff00";
        # };
        # colors.unfocused = {
        #   border = inactive-bg-color;
        #   childBorder = inactive-bg-color;
        #   background = inactive-bg-color;
        #   text = inactive-text-color;
        #   indicator = "#00ff00";
        # };
        # colors.focusedInactive = {
        #   border = inactive-bg-color;
        #   childBorder = inactive-bg-color;
        #   background = inactive-bg-color;
        #   text = inactive-text-color;
        #   indicator = "#00ff00";
        # };
        # colors.urgent = {
        #   border = urgent-bg-color;
        #   childBorder = urgent-bg-color;
        #   background = urgent-bg-color;
        #   text = text-color;
        #   indicator = "#00ff00";
        # };
      };
    };

    # xdg.configFile."xdg-desktop-portal-wlr/config".text = ''
    #   [screencast]
    #   output_name=
    #   max_fps=30
    #   chooser_cmd=${pkgs.slurp}/bin/slurp -f %o -or
    #   chooser_type=simple
    # '';

  };
}
