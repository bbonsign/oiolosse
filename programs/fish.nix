{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    shellAliases = import ./shellAliases.nix;

    shellAbbrs = import ./shellAbbrs.nix;

    plugins = [{
      name = "fzf";
      src = pkgs.fetchFromGitHub {
        owner = "oddlama";
        repo = "fzf.fish";
        rev = "6331eedaf680323dd5a2e2f7fba37a1bc89d6564";
        sha256 = "sha256-BO+KFvHdbBz7SRA6EuOk2dEC8zORsCH9V04dHhJ6gxw=";
      };
    }];
  };
}
