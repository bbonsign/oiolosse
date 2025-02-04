{ pkgs, ... }:

{
  imports = [
    ../../_mixins/programs
    ../../_mixins/desktops/gnome
    # ../../_mixins/desktops/sway
  ];

  config = {
    home.username = "bbonsign";
    home.homeDirectory = "/home/bbonsign";
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      GRIM_DEFAULT_DIR = "$HOME/Pictures/Screenshots";
    };

    services.ssh-agent.enable = true;

    # https://nixos.wiki/wiki/Bluetooth#Using_Bluetooth_headset_buttons_to_control_media_player
    services.mpris-proxy.enable = true;

    # Link configs that don't have home-manager modules
    home.file = {
      ".iex.exs".source = ../../_mixins/dot_iex.exs;
      ".ipython/profile_default/ipython_config.py".source = ../../_mixins/ipython_config.py;
      ".local/bin" = {
        source = ./local-bin;
        recursive = true;
      };
    };

    # home.shellAliases = import ../programs/shellAliases.nix;

    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
      # asdf-vm
      awscli2
      bat
      # bazecor
      bottom
      # cargo
      # chezmoi
      # chromium
      # copilot-cli # AWS ECS cli 
      cowsay
      delta
      # devbox
      dnsutils # `dig` + `nslookup`
      duckdb
      duf
      beam.packages.erlang_27.erlang
      beam.packages.erlang_27.elixir_1_18
      # elixir_1_16
      # erlang
      eza
      file
      flyctl
      gcc
      gh # GitHub cli
      # ghostty
      glow # markdown previewer in terminal
      gnumake
      gnupg
      gnused
      go
      gum # charm cli scripting helper
      htop
      httpie
      inotify-tools
      jless
      jq
      just
      kanata
      killall
      lazygit
      litecli
      # livebook
      luarocks
      # nixfmt
      nix-output-monitor
      nodejs
      # opentofu
      p7zip
      newman
      nodePackages.pnpm
      # pipenv
      # python312Packages.ipython
      pgcli
      # podman
      # podman-compose
      # podman-tui
      # poetry
      # qutebrowser
      ripgrep
      # rustup
      ssm-session-manager-plugin # For aws cli
      # slack
      tealdeer
      television
      trashy
      tree
      unzip
      usbutils # lsusb
      uv # python packaging and project manager
      # valent # KDE Connect client
      which
      wl-clipboard
      xz
      yarn
      yazi
      yq-go # yaml processer https://github.com/mikefarah/yq
      # zig
      zip
      # zls # zig language server
      # from nixos sway
      brightnessctl
      fuzzel
      rofi-wayland
      swappy # screenshot annotation tool
      sway-contrib.grimshot
      swaynotificationcenter
      slurp # screen selection functionality
      waybar
      wev # Wayland event viewer
      wlprop # click to get window details
      wmenu
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
  };
}
