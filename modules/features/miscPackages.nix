_: 
{
  flake.homeModules.miscPackages = {pkgs, ...}: {

    config = {
      # Packages that should be installed to the user profile.
      home.packages = [
        # devbox
        # ghostty
        # podman
        # podman-compose
        # podman-tui
        # qutebrowser
        # valent # KDE Connect client
        # websocat
        pkgs.asciinema_3
        pkgs.age
        # amp-cli
        pkgs.awscli2
        pkgs.ast-grep
        pkgs.bat
        pkgs.bottom
        pkgs.brightnessctl
        pkgs.btop
        pkgs.bun
        pkgs.cargo
        pkgs.cbonsai
        pkgs.cmatrix
        # codex
        pkgs.cowsay
        pkgs.delta
        # diffnav # Delta + file tree -- installed from local clone for now
        # difftastic
        pkgs.dnsutils # `dig` + `nslookup`
        pkgs.duckdb
        pkgs.duf
        pkgs.exiftool
        pkgs.eza
        pkgs.file
        # flyctl
        pkgs.gcc
        pkgs.glow # terminal markdown previewer
        pkgs.gnumake
        pkgs.gnupg
        pkgs.gnused
        pkgs.go
        pkgs.google-chrome
        pkgs.gum # charm cli scripting helper
        pkgs.hexyl
        pkgs.htop
        pkgs.hyprpicker
        pkgs.inotify-tools
        pkgs.jc # converts many command outputs/data types to json
        pkgs.jq
        # just
        pkgs.killall
        pkgs.kitty
        pkgs.litecli
        pkgs.lua-language-server
        pkgs.luarocks
        pkgs.mermaid-cli
        pkgs.nautilus
        # networkmanager
        # networkmanager-openvpn
        # pnpm
        pkgs.nodejs
        pkgs.ntfy-sh
        pkgs.numbat # Scientific calculator/programming language
        # obsidian # Using flatpak for now
        pkgs.p7zip
        pkgs.pandoc
        # pgadmin4
        pkgs.pgcli
        pkgs.pinentry-gtk2
        pkgs.postgresql
        pkgs.presenterm
        # quickshell
        pkgs.ripgrep
        pkgs.sioyek
        pkgs.snyk
        pkgs.snowsql
        pkgs.sops
        pkgs.sqlite
        # ssm-session-manager-plugin # For aws cli
        pkgs.stylua
        pkgs.systemctl-tui
        pkgs.tealdeer
        pkgs.television
        pkgs.topiary # treesitter based formatter
        pkgs.trashy
        pkgs.tree
        pkgs.unzip
        pkgs.usbutils # lsusb
        pkgs.uv # python packaging and project manager
        # watchman
        pkgs.which
        pkgs.xdg-desktop-portal-gnome
        pkgs.xz
        pkgs.yarn
        pkgs.yazi
        pkgs.yq-go # yaml processer https://github.com/mikefarah/yq
        pkgs.zip
      ];

    };
  };
}
