{
  inputs,
  lib,
  ...
}: {
  perSystem = {pkgs, ...}: let
    conf = ../../dotfiles/starship.toml;
  in {
    packages.starship = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.starship;
      env = {
        STARSHIP_CONFIG = "${conf}";
      };
    };
  };
}
