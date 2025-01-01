{ inputs, pkgs, ... }:

{
  imports =
    [
      ./users/bbonsign/home.nix
      inputs.nix-index-database.hmModules.nix-index
    ];

  config = {
    # Let home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.nix-index.enable = true;
    programs.nix-index-database.comma.enable = true;

    nix = {
      package = pkgs.nixVersions.stable;
      extraOptions = ''
        experimental-features = nix-command flakes pipe-operators
      '';
    };

    home.shellAliases = import ./_mixins/programs/shellAliases.nix;

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";
      size = 24;
    };
  };
}
