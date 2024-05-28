{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgsStable.url = "github:nixos/nixpkgs/release-23.05";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # home-manager.inputs.nixpkgsStable.follows = "nixpkgsStable";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nix-index-database,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        mithlond = nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./nixos/mithlond/configuration.nix

            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;

              home-manager.useUserPackages = true;

              home-manager.backupFileExtension = "hmbak";
              home-manager.users.bbonsign = import ./home-manager/bbonsign/home.nix;

              # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
            }
          ];
        };
      };

      homeConfigurations = {
        "bbonsign" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = system; };

          # Specify your home configuration modules here, for example, the path to your home.nix.
          modules = [ ./home-manager/bbonsign/home.nix ];

          # Optionally use extraSpecialArgs to pass through arguments to home.nix
          extraSpecialArgs = {
            inherit inputs;
          };
        };
      };

      formatter = {
        x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      };
    };
}
