{
inputs,
self,
...
}:
let
  # Overlays / nixpkgs config that are safe to apply only when Home-Manager
  # owns its own pkgs (i.e. standalone, NOT under `home-manager.useGlobalPkgs`).
  standaloneNixpkgs = {
    nixpkgs.overlays = [
      inputs.neovim-nightly-overlay.overlays.default
    ];
    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = _pkg: true;
    };
  };
in {
  flake.homeConfigurations.bbonsign = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";

    # Specify your home configuration modules here, for example, the path to your home.nix.
    modules = [
      self.homeModules.bbonsignHomeModule
      standaloneNixpkgs
    ];
  };

  flake.homeModules.bbonsignHomeModule = {pkgs, ...}: {
    imports = [
      self.homeModules.beam
      self.homeModules.bluetooth
      self.homeModules.cursor
      self.homeModules.desktops
      self.homeModules.font
      self.homeModules.hm-programs
      self.homeModules.home-manager
      self.homeModules.misc-packages
      self.homeModules.nix
      self.homeModules.shell-prompt
      self.homeModules.shells
      self.homeModules.ssh
      self.homeModules.terminalFun
      self.homeModules.vcs
      self.homeModules.xdg
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
        # Hint electron apps to use wayland:
        NIXOS_OZONE_WL = "1";
        # npm global prefix (writable alternative to Nix store)
        NPM_CONFIG_PREFIX = "$HOME/.npm-global";
      };

      home.sessionPath = [
        "$HOME/.npm-global/bin"
      ];

      services = {
        gnome-keyring.enable = true;
      };

    };
  };
}
