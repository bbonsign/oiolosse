{ inputs, ... }:

{
  imports =
    [ ./users/bbonsign/home.nix inputs.nix-index-database.hmModules.nix-index ];

  config = {
    # Let home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.nix-index.enable = true;
    programs.nix-index-database.comma.enable = true;

    home.shellAliases = import ./_mixins/programs/shellAliases.nix;
  };
}
