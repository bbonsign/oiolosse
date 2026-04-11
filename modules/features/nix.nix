{inputs, self, pkgs, ...}:
{
  flake.homeModules.nix = {pkgs,...}: {
    imports = [
      inputs.nix-index-database.homeModules.nix-index
    ];

    config = {
      programs.nix-index.enable = true;
      programs.nix-index-database.comma.enable = true;
      home.packages = [
        pkgs.nix-output-monitor
        self.packages.x86_64-linux.nh
      ];
    };
  };
}
