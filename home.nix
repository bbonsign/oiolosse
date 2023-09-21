{ config, pkgs, ... }:

{
  # TODO please change the username & home directory to your own
  home.username = "bbonsign";
  home.homeDirectory = "/home/bbonsign";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

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

  # basic configuration of git, please change to your own
  # programs.git = {
  #   enable = true;
  #   userName = "Ryan Yin";
  #   userEmail = "xiaoyin_c@qq.com";
  # };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    chezmoi

    kitty
    chromium

    nushell
    fd
    ripgrep
    fzf
    bat
    delta
    tealdeer
    wl-clipboard
    eza
    nnn
    lazygit
    gh # GitHub cli
    just

    trashy

    slack

    stylua
    luarocks

    neofetch

    podman
    podman-compose
    poetry
    pipenv

    go
    gcc
    cargo
    gnumake
    nodejs

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    fzf # A command-line fuzzy finder
    zellij

    # misc
    cowsay
    file
    which
    tree
    gnused
    # gnutar
    # gawk
    # zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix
    # with more details log output
    nix-output-monitor

    glow # markdown previewer in terminal

    duf
    btop
    htop

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

  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    extraPackages = with pkgs; [ gcc rnix-lsp sumneko-lua-language-server ];
  };

  # programs.kitty = {
  #   enable = true;
  #   theme = "Tokyo Night";
  #   settings = {
  #     font_family = "FiraCode Nerd Font Med";
  #     bold_font = "FiraCode Nerd ont Bold";
  #     hide_window_decorations = "yes";
  #     dynamic_background_opacity = "yes";
  #     background_opacity = "0.7";
  #   };
  # };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      line_break.disabled = false;
      aws.disabled = true;
      gcloud.disabled = true;

      character = {
        success_symbol = "[λ](bold blue)";
        error_symbol = "[λ](bold red)";
      };
      elixir = {
        symbol = " ";
        style = "#5e3f9e";
      };
      haskell.symbol = " ";
      lua.symbol = " ";
      python.symbol = " ";
      docker_context.symbol = " ";
      elm.symbol = " ";
      git_branch.symbol = " ";
      golang.symbol = " ";
      rust.symbol = " ";
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    # set some aliases, feel free to add more or remove some
    # shellAliases = {
    #   urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    #   urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    #   httpproxy = "export https_proxy=http://127.0.0.1:7890; export http_proxy=http://127.0.0.1:7890;";
    # };
  };

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
}
