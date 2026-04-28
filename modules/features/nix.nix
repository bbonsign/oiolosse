{inputs, self, ...}:
{
  flake.homeModules.nix = _:
    {
      imports = [
        inputs.nix-index-database.homeModules.nix-index
      ];

      config = {
        programs.nix-index.enable = true;
        programs.nix-index-database.comma.enable = true;
        home.packages = [
          self.packages.x86_64-linux.nh
        ];
      };
    };

  flake.nixosModules.nix = {pkgs,...}:
    {
      config ={
        # Allow unfree packages
        nixpkgs.config.allowUnfree = true;
        nix = {
          package = pkgs.nixVersions.stable;
          extraOptions = ''
          experimental-features = nix-command flakes pipe-operators
          download-buffer-size = 524288000 # 500MiB (default: 64 MiB)
          '';
        };
      };
    };
}
