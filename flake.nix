{
  description = "My NixOS configuration";

  # nixConfig = {
  #   extra-substituters = [ "https://noctalia.cachix.org" ];
  #   extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  # };
  #
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
    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";

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
      # inputs.nixpkgs.follows = "nixpkgs";
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
