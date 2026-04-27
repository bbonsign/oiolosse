{ inputs, pkgs, self, ... }:

{
  imports = [
    # adds home-manager options to flake-parts
    inputs.home-manager.flakeModules.home-manager
    inputs.wrappers.flakeModules.wrappers
  ];

  options = {
    # flake = inputs.flake-parts.lib.mkSubmoduleOptions {
    #   wrappersModules = inputs.nixpkgs.lib.mkOption {
    #     default = {};
    #   };
    # };
  };

  config = {
    systems = [
      "x86_64-linux"
      # "aarch64-linux"
      # "x86_64-darwin"
      # "aarch64-darwin"
    ];

    # TODO: Old flake outputs to be split up incrementally
    flake = {
      nixosConfigurations = {
        mithlond = inputs.nixpkgs.lib.nixosSystem {
          # inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./_nixos/mithlond
            ./_nixos_mods

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
              # home-manager.extraSpecialArgs = { inherit inputs; isNixOS = true; };
            }
          ];
        };
      };

    };
  };
}
