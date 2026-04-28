{ inputs, pkgs, self, ... }:
{
  flake.nixosConfigurations = {
    mithlond = inputs.nixpkgs.lib.nixosSystem {
      # inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./_hardware-configuration.nix

        self.nixosModules."1password"
        self.nixosModules.bazecor
        self.nixosModules.boot
        self.nixosModules.containers
        self.nixosModules.home-manager
        self.nixosModules.keyboard
        self.nixosModules.locale
        self.nixosModules.misc-packages
        self.nixosModules.networking
        self.nixosModules.pipewire
        self.nixosModules.printing
        self.nixosModules.shells
        self.nixosModules.tailscale
        self.nixosModules.users

        # When `home-manager.useGlobalPkgs = true`, HM cannot set
        # `nixpkgs.{overlays,config}` itself, so configure them here at
        # the NixOS level instead.
        {
          nixpkgs.overlays = [
            inputs.neovim-nightly-overlay.overlays.default
          ];
          nixpkgs.config = {
            allowUnfree = true;
            allowUnfreePredicate = _pkg: true;
          };
        }

        {
          # This value determines the NixOS release from which the default
          # settings for stateful data, like file locations and database versions
          # on your system were taken. It‘s perfectly fine and recommended to leave
          # this value at the release version of the first install of this system.
          # Before changing this value read the documentation for this option
          # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
          system.stateVersion = "23.05"; # Did you read the comment?
        }
      ];
    };
  };

}
