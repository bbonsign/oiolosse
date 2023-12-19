{ pkgs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    # shellAliases = import ./shellAliases.nix;
    sessionVariables = {
      MANPAGER = "nvim +Man!";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
