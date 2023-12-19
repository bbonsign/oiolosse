{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    defaultKeymap = "emacs";
    dotDir = ".config/zsh";

    syntaxHighlighting.enable = true;

    # shellAliases = import ./shellAliases.nix;
    sessionVariables = {
      MANPAGER = "nvim +Man!";
      EDITOR = "nvim";
      VISUAL = "nvim";
      FZF_COMPLETION_TRIGGER = "";
    };

    zsh-abbr = {
      enable = true;
      abbreviations = import ./shellAbbrs.nix;
    };
  };
}
