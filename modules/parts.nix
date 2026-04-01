{ inputs, ... }:

{
  imports = [
    # adds home-manager options to flake-parts
    inputs.home-manager.flakeModules.home-manager
    inputs.wrapper-modules.flakeModules.wrappers
  ];

  options = {
    flake = inputs.flake-parts.lib.mkSubmoduleOptions {
      wrappersModules = inputs.nixpkgs.lib.mkOption {
        default = {};
      };
    };
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

            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hmbak";
              home-manager.users.bbonsign = import ./_home-manager/bbonsign;
              # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
          ];
        };
      };

      homeConfigurations = {
        "bbonsign" = inputs.home-manager.lib.homeManagerConfiguration {
          # pkgs = nixpkgs.legacyPackages.${system};

          # Specify your home configuration modules here, for example, the path to your home.nix.
          modules = [
            ./_home-manager/bbonsign
          ];

          # Optionally use extraSpecialArgs to pass through arguments to home.nix
          # extraSpecialArgs = { inherit inputs system; };
          extraSpecialArgs = { inherit inputs; };
        };
      };

    };
  };
}
