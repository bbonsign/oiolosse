{
  inputs,
  lib,
  ...
}: {
  perSystem = {pkgs, ...}: let
    confDir = ../../dotfiles/kitty;
  in {
    packages.kitty = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.kitty;
      env = {
        KITTY_CONFIG_DIRECTORY = "${confDir}";
      };
    };
  };
}
