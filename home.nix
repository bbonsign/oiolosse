{ config, pkgs, nix-index-database, ... }:

{

  home.username = "bbonsign";
  home.homeDirectory = "/home/bbonsign";

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  imports = builtins.concatMap import [ ./programs ]
    ++ [ nix-index-database.hmModules.nix-index ];

  services.ssh-agent.enable = true;

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.nix-index.enable = true;
  programs.nix-index.enableBashIntegration = true;
  programs.nix-index.enableFishIntegration = true;
  programs.nix-index.enableZshIntegration = true;

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

  home.file.".iex.exs".source = ./dot_iex.exs;

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
    duf
    elixir
    erlang
    eza
    fd
    file
    firefox
    fzf
    fzf
    gcc
    gh # GitHub cli
    glow # markdown previewer in terminal
    gnome.gnome-tweaks
    gnome.gnome-themes-extra
    gnumake
    gnupg
    gnused
    go
    htop
    jq
    just
    keyd
    killall
    kitty
    lazygit
    livebook
    luarocks
    neofetch
    nix-output-monitor
    nnn
    nodejs
    nushell
    p7zip
    pipenv
    podman
    podman-compose
    podman-tui
    poetry
    ripgrep
    ripgrep
    slack
    tealdeer
    trashy
    tree
    unzip
    usbutils # lsusb
    which
    wl-clipboard
    xz
    yq-go # yaml processer https://github.com/mikefarah/yq
    zellij
    zip
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      "show-battery-percentage" = true;
    };

    "org/gnome/clocks" = {
      world-clocks =
        "[{'location': <(uint32 2, <('Sacramento', 'KSAC', true, [(0.67207295768107522, -2.1204877747105106)], [(0.67337546199525378, -2.1204773027349986)])>)>}, {'location': <(uint32 2, <('London', 'EGWU', true, [(0.89971722940307675, -0.007272211034407213)], [(0.89884456477707964, -0.0020362232784242244)])>)>}]";
    };

    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file://${./wallpapers/stsci-h-p1821a-m-1699x2000.png}";
      picture-uri-dark =
        "file://${./wallpapers/stsci-h-p1821a-m-1699x2000.png}";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };
  };
}
