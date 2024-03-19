{ config, pkgs, nix-index-database, home-manager, ... }:

{
  imports = builtins.concatMap import [ ./programs ]
    ++ [ nix-index-database.hmModules.nix-index ./dconf.nix ];

  home.username = "bbonsign";
  home.homeDirectory = "/home/bbonsign";

  services.ssh-agent.enable = true;

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # Link configs that don't have home-manager modules
  home.file = {
    ".iex.exs".source = ./dot_iex.exs;
    ".ipython/profile_default/ipython_config.py".source = ./ipython_config.py;
  };
  xdg.configFile."fd/ignore".source = ./programs/fdignore;
  xdg.configFile."zellij" = {
    source = ./programs/zellij;
    recursive = true;
  };

  home.shellAliases = import ./programs/shellAliases.nix;

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    awscli2
    bat
    bazecor
    bottom
    cargo
    chezmoi
    chromium
    cowsay
    delta
    devbox
    distrobox
    dnsutils # `dig` + `nslookup`
    duckdb
    duf
    elixir
    erlang
    eza
    fd
    file
    firefox
    gcc
    gh # GitHub cli
    glow # markdown previewer in terminal
    gnome.gnome-tweaks
    gnome.gnome-themes-extra
    # gnomeExtensions.hide-top-bar
    # gnomeExtensions.valent
    gnumake
    gnupg
    gnused
    go
    htop
    jq
    just
    killall
    kitty
    lazygit
    livebook
    luarocks
    neofetch
    # nixd # nix lsp
    nixfmt
    nix-output-monitor
    nnn
    nodejs
    nushell
    p7zip
    # pipenv
    pkgs.python312Packages.ipython
    # podman
    # podman-compose
    podman-tui
    poetry
    qutebrowser
    ripgrep
    ripgrep
    slack
    tealdeer
    tmux
    trashy
    tree
    unzip
    usbutils # lsusb
    # valent # KDE Connect client
    which
    wl-clipboard
    xz
    yq-go # yaml processer https://github.com/mikefarah/yq
    zellij
    # zig
    zip
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

}
