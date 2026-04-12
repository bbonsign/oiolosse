{ inputs, pkgs, lib, isNixOS, ... }:

{
  imports = [
    ./modules
  ] ++ lib.optionals (!isNixOS) [
    {
      nixpkgs.overlays = [
        inputs.neovim-nightly-overlay.overlays.default
      ];
      nixpkgs.config = {
        allowUnfree = true;
        allowUnfreePredicate = _pkg: true;
      };
    }
  ];

  config = {
    home.sessionVariables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "kitty";
      GRIM_DEFAULT_DIR = "$HOME/Pictures/Screenshots";
      ERL_AFLAGS = "-kernel shell_history enabled";
      # Hint electron apps to use wayland:
      NIXOS_OZONE_WL = "1";
    };

    # nix = {
    #   package = pkgs.nixVersions.stable;
    #   extraOptions = ''
    #     experimental-features = nix-command flakes pipe-operators
    #   '';
    # };


    home.shellAliases = import ./modules/programs/shellAliases.nix;

    services = {
      gnome-keyring.enable = true;
    };

  };
}
