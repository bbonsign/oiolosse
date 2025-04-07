{ inputs, pkgs, ... }:

{
  imports = [
    ./modules
    inputs.nix-index-database.hmModules.nix-index
  ];

  config = {
    home.username = "bbonsign";
    home.homeDirectory = "/home/bbonsign";
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      GRIM_DEFAULT_DIR = "$HOME/Pictures/Screenshots";
    };

    # nix = {
    #   package = pkgs.nixVersions.stable;
    #   extraOptions = ''
    #     experimental-features = nix-command flakes pipe-operators
    #   '';
    # };

    home.shellAliases = import ./modules/programs/shellAliases.nix;

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";
      size = 24;
    };


    # Link configs that don't have home-manager modules
    home.file = {
      ".local/bin" = {
        source = ./local-bin;
        recursive = true;
      };
    };

    # home.shellAliases = import ../programs/shellAliases.nix;

    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
      # asdf-vm
      bazecor
      # cargo
      # chezmoi
      # chromium
      # copilot-cli # AWS ECS cli 
      # devbox
      # elixir_1_16
      # erlang
      # from nixos sway
      # ghostty
      # jless
      # livebook
      # nixfmt
      # pipenv
      # podman
      # podman-compose
      # podman-tui
      # poetry
      # python312Packages.ipython
      # qutebrowser
      # rustup
      # slack
      # television
      # valent # KDE Connect client
      # yazi
      # zig
      # zls # zig language server
      awscli2
      bat
      beam.packages.erlang_27.elixir_1_18
      beam.packages.erlang_27.erlang
      bottom
      brightnessctl
      cowsay
      delta
      dnsutils # `dig` + `nslookup`
      duckdb
      duf
      eza
      file
      flyctl
      gcc
      gh # GitHub cli
      glow # terminal markdown previewer
      gnumake
      gnupg
      gnused
      go
      gum # charm cli scripting helper
      htop
      httpie
      inotify-tools
      jq
      just
      kanata
      killall
      kitty
      lazygit
      litecli
      luarocks
      nautilus
      newman
      nix-output-monitor
      nodePackages.pnpm
      nodejs
      obsidian
      p7zip
      pgcli
      ripgrep
      ssm-session-manager-plugin # For aws cli
      tealdeer
      topiary # treesitter based formatter
      trashy
      tree
      unzip
      usbutils # lsusb
      uv # python packaging and project manager
      which
      xz
      yarn
      yq-go # yaml processer https://github.com/mikefarah/yq
      zig
      zip
      zls # zig language server
    ];

    # This value determines the home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update home Manager without changing this value. See
    # the home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "22.11";

    # Let home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.nix-index.enable = true;
    programs.nix-index-database.comma.enable = true;

    services = {
      ssh-agent.enable = true;
      # https://nixos.wiki/wiki/Bluetooth#Using_Bluetooth_headset_buttons_to_control_media_player
      mpris-proxy.enable = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
      config.common.default = [ "*" ];
    };
  };
}
