{self, ...}:
{
  flake.homeModules.misc-packages = {pkgs, ...}: {
    config = {
      # Packages that should be installed to the user profile.
      home.packages = [
        # pkgs.podman
        # pkgs.podman-compose
        # pkgs.podman-tui
        # pkgs.valent # KDE Connect client
        # pkgs.websocat
        pkgs.asciinema
        pkgs.age
        pkgs.awscli2
        pkgs.ast-grep
        pkgs.bat
        pkgs.bottom
        pkgs.brightnessctl
        pkgs.btop
        pkgs.bun
        pkgs.cargo
        pkgs.delta
        # pkgs.diffnav # Delta + file tree -- installed from local clone for now
        pkgs.dnsutils # `dig` + `nslookup`
        pkgs.duckdb
        pkgs.duf
        pkgs.exiftool
        pkgs.eza
        pkgs.file
        pkgs.gcc
        pkgs.glow # terminal markdown previewer
        pkgs.gnumake
        pkgs.gnupg
        pkgs.gnused
        pkgs.go
        # pkgs.google-chrome
        pkgs.gum # charm cli scripting helper
        pkgs.hexyl
        pkgs.htop
        pkgs.hyprpicker
        pkgs.inotify-tools
        pkgs.jc # converts many command outputs/data types to json
        pkgs.jq
        # pkgs.just
        pkgs.killall
        pkgs.kitty
        # pkgs.litecli
        pkgs.lua-language-server
        pkgs.luarocks
        pkgs.mermaid-cli
        # pkgs.mpv
        pkgs.nautilus
        # pkgs.networkmanager
        # pkgs.networkmanager-openvpn
        pkgs.nodejs
        pkgs.nom
        pkgs.ntfy-sh
        pkgs.numbat # Scientific calculator/programming language
        # pkgs.obsidian # Using flatpak for now
        pkgs.p7zip
        pkgs.pandoc
        # pkgs.pgcli
        pkgs.pinentry-gnome3 
        pkgs.pnpm
        # pkgs.postgresql
        pkgs.presenterm
        pkgs.ripgrep
        pkgs.ruff
        pkgs.sioyek
        pkgs.snyk
        pkgs.snowsql
        pkgs.sops
        pkgs.sqlite
        # pkgs.ssm-session-manager-plugin # For aws cli
        pkgs.stylua
        pkgs.systemctl-tui
        pkgs.tealdeer
        pkgs.television
        pkgs.topiary # treesitter based formatter
        pkgs.trashy
        pkgs.tree
        pkgs.tree-sitter
        pkgs.unzip
        pkgs.usbutils # lsusb
        pkgs.uv
        pkgs.which
        pkgs.xdg-desktop-portal-gnome
        # pkgs.xz
        pkgs.yazi
        pkgs.yq-go # yaml processer https://github.com/mikefarah/yq
        pkgs.zip
        ## Wrapped packages
        # self.packages.x86_64-linux.lf
      ];

    };
  };

  flake.nixosModules.misc-packages = {pkgs,...}: {
    config = {
      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = [
        # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        pkgs.brightnessctl
        pkgs.distrobox
        pkgs.firefox
        pkgs.git
        pkgs.inotify-tools
        pkgs.ncurses
        pkgs.neovim
        pkgs.pciutils
        pkgs.python312
        pkgs.sqlite
        pkgs.vivaldi
        pkgs.wget
        pkgs.wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      ];
    };
  };

}
