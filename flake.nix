{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-formatter-pack = {
      url = "github:Gerschtli/nix-formatter-pack";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # niri = {
    #   url = "github:YaLTeR/niri";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs@{ nixpkgs, home-manager, nix-formatter-pack, ... }:
    let system = "x86_64-linux";
    in {
      nixosConfigurations = {
        mithlond = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos/mithlond
            ./modules/nixos

            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hmbak";
              home-manager.users.bbonsign = import ./home-manager/bbonsign;
              # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
          ];
        };
      };

      homeConfigurations = {
        "bbonsign" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };

          # Specify your home configuration modules here, for example, the path to your home.nix.
          modules = [
            ./home-manager/bbonsign
            ./modules/home-manager
          ];

          # Optionally use extraSpecialArgs to pass through arguments to home.nix
          extraSpecialArgs = { inherit inputs; };
        };
      };

      # nix fmt
      formatter.x86_64-linux = nix-formatter-pack.lib.mkFormatter {
        pkgs = nixpkgs.legacyPackages.${system};
        config.tools = {
          alejandra.enable = false;
          deadnix.enable = true;
          nixpkgs-fmt.enable = true;
          statix.enable = true;
        };
      };
    };
}
