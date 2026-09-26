{ inputs, ... }:
{
  flake.homeModules.noctalia = { pkgs, ... }: {
    config = {
      programs.noctalia = {
        enable = true;
        package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
        # systemd.enable = true;
      };
    };
  };
}
