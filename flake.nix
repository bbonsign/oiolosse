{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";

    # wrappers.url = "github:Lassulus/wrappers";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
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

    niri = {
      url = "github:YaLTeR/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jjui = {
      url = "github:idursun/jjui";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake
      {inherit inputs;}
      (inputs.import-tree ./modules);

  # outputs = inputs@{ nixpkgs, home-manager, nix-formatter-pack, ... }:
  #   let system = "x86_64-linux";
  #   in {
  #     nixosConfigurations = {
  #       mithlond = nixpkgs.lib.nixosSystem {
  #         inherit system;
  #         specialArgs = { inherit inputs; };
  #         modules = [
  #           ./nixos/mithlond
  #           ./modules/nixos
  #
  #           # make home-manager as a module of nixos
  #           # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
  #           home-manager.nixosModules.home-manager
  #           {
  #             home-manager.useGlobalPkgs = true;
  #             home-manager.useUserPackages = true;
  #             home-manager.backupFileExtension = "hmbak";
  #             home-manager.users.bbonsign = import ./home-manager/bbonsign;
  #             # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
  #             home-manager.extraSpecialArgs = { inherit inputs; };
  #           }
  #         ];
  #       };
  #     };
  #
  #     homeConfigurations = {
  #       "bbonsign" = home-manager.lib.homeManagerConfiguration {
  #         pkgs = nixpkgs.legacyPackages.${system};
  #
  #         # Specify your home configuration modules here, for example, the path to your home.nix.
  #         modules = [
  #           ./home-manager/bbonsign
  #           ./modules/home-manager
  #         ];
  #
  #         # Optionally use extraSpecialArgs to pass through arguments to home.nix
  #         extraSpecialArgs = { inherit inputs system; };
  #       };
  #     };
  #
  #     # nix fmt
  #     formatter.x86_64-linux = nix-formatter-pack.lib.mkFormatter {
  #       pkgs = nixpkgs.legacyPackages.${system};
  #       config.tools = {
  #         alejandra.enable = false;
  #         deadnix.enable = true;
  #         nixpkgs-fmt.enable = true;
  #         statix.enable = true;
  #       };
  #     };
  #   };
}
