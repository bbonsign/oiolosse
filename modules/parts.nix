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

  };
}
