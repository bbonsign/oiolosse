{ config, pkgs, ... }:

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

  imports = builtins.concatMap import [ ./programs ];
  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.ssh-agent.enable = true;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  home.file.".iex.exs".source = ./dotfiles/dot_iex.exs;

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # rtx - asdf clone in Rust
  programs.rtx.enable = true;

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    bat
    btop
    cargo
    chezmoi
    chromium
    cowsay
    delta
    duf
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
    luarocks
    neofetch
    nnn
    nodejs
    nushell
    pipenv
    podman
    podman-compose
    poetry
    ripgrep
    ripgrep
    slack
    # stylua
    tealdeer
    trashy
    tree
    which
    wl-clipboard
    yq-go # yaml processer https://github.com/mikefarah/yq
    zellij
    # archives
    zip
    xz
    unzip
    p7zip

    # Provides the command `nom` works just like `nix
    # with more details log output
    nix-output-monitor

    # networking tools
    # mtr # A network diagnostic tool
    # iperf3
    # dnsutils  # `dig` + `nslookup`
    # ldns # replacement of `dig`, it provide the command `drill`
    # aria2 # A lightweight multi-protocol & multi-source command-line download utility
    # socat # replacement of openbsd-netcat
    # nmap # A utility for network discovery and security auditing
    # ipcalc  # it is a calculator for the IPv4/v6 addresses

    # iotop # io monitoring
    # iftop # network monitoring

    # system call monitoring
    # strace # system call monitoring
    # ltrace # library call monitoring
    # lsof # list open files

    # system tools
    # sysstat
    # lm_sensors # for `sensors` command
    # ethtool
    # pciutils # lspci
    # usbutils # lsusb
  ];
}
