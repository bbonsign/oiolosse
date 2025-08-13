{ inputs, pkgs, system, ... }:

{
  imports = [
    ./modules
    inputs.nix-index-database.homeModules.nix-index
  ];

  config = {
    home.username = "bbonsign";
    home.homeDirectory = "/home/bbonsign";
    home.sessionVariables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "kitty";
      GRIM_DEFAULT_DIR = "$HOME/Pictures/Screenshots";
      ERL_AFLAGS = "-kernel shell_history enabled";
    };

    # nix = {
    #   package = pkgs.nixVersions.stable;
    #   extraOptions = ''
    #     experimental-features = nix-command flakes pipe-operators
    #   '';
    # };

    fonts.fontconfig.enable = true;

    home.shellAliases = import ./modules/programs/shellAliases.nix;

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";
      size = 24;
    };


    # # Link configs that don't have home-manager modules
    # home.file = {
    #   ".local/bin" = {
    #     source = ./local-bin;
    #     recursive = true;
    #   };
    # };

    # home.shellAliases = import ../programs/shellAliases.nix;

    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
      # asdf-vm
      # copilot-cli # AWS ECS cli 
      # devbox
      # ghostty
      # jless
      # nixfmt
      # podman
      # podman-compose
      # podman-tui
      # python312Packages.ipython
      # qutebrowser
      # rustup
      # television
      # valent # KDE Connect client
      # websocat
      # zig
      # zls # zig language server
      age
      awscli2
      bat
      beam.packages.erlang_27.elixir_1_18
      beam.packages.erlang_27.erlang
      bottom
      brightnessctl
      bun
      cargo
      cowsay
      cbonsai
      cmatrix
      delta
      dnsutils # `dig` + `nslookup`
      duckdb
      duf
      eww
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
      jc # converts many command outputs/data types to json
      jq
      # jjui
      inputs.jjui.packages.x86_64-linux.jjui
      # inputs.starship-jj.packages.x86_64-linux.starship-jj
      jujutsu
      just
      killall
      kitty
      lazygit
      litecli
      lua-language-server
      luarocks
      mermaid-cli
      nautilus
      nerd-fonts.fira-code
      nerd-fonts.fantasque-sans-mono
      networkmanager
      newman
      nh
      nix-output-monitor
      nodePackages.aws-cdk
      nodePackages.pnpm
      nodejs
      ntfy-sh
      numbat # Scientific calculator/programming language
      obsidian
      p7zip
      pandoc
      pgadmin4
      pgcli
      # https://linkfrg.github.io/ignis/stable/user/nix.html#adding-ignis-to-system-python 
      # inputs.ignis.packages.${system}.ignis
      (python3.withPackages (ps: with ps; [
        (inputs.ignis.packages.${pkgs.stdenv.hostPlatform.system}.ignis.override {
          extraPackages = [
            # Add extra packages if needed
          ];
        })
      ]))
      pinentry-gtk2
      presenterm
      ripgrep
      snyk
      sops
      sqlite
      ssm-session-manager-plugin # For aws cli
      stylua
      systemctl-tui
      tealdeer
      topiary # treesitter based formatter
      trashy
      tree
      unzip
      usbutils # lsusb
      uv # python packaging and project manager
      watchman
      which
      xz
      yarn
      yazi
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
      ];
      config.common.default = [ "gtk;wlr" ];
    };
  };
}
