{ inputs, pkgs, self, ... }:
{
  flake.nixosConfigurations = {
    mithlond = inputs.nixpkgs.lib.nixosSystem {
      # inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./_configuration.nix 

        self.nixosModules."1password"
        self.nixosModules.bazecor

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

        # make home-manager as a module of nixos
        # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
        inputs.home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hmbak";
          home-manager.users.bbonsign = self.homeModules.bbonsignHomeModule;
        }

        # Since Home Manager is installed via its NixOS module and 'home-manager.useUserPackages' is
        # enabled, you need to add the following to your NixOS configuration so that the portal
        # definitions and DE provided configurations get linked.
        {
          environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];
        }
      ];
    };
  };

}
