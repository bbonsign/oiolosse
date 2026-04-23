_:

{
  flake.homeModules.zsh = {config, ...}:

    {
      config = {
        programs.zsh = {
          enable = true;
          autosuggestion = { enable = true; };
          enableCompletion = true;

          defaultKeymap = "emacs";
          dotDir = "${config.xdg.configHome}/zsh";

          syntaxHighlighting.enable = true;

          # shellAliases = import ./_shellAliases.nix;
          sessionVariables = {
            MANPAGER = "nvim +Man!";
            EDITOR = "nvim";
            VISUAL = "nvim";
            FZF_COMPLETION_TRIGGER = "";
          };

          zsh-abbr = {
            enable = true;
            abbreviations = import ./_shellAbbrs.nix;
          };
        };
      };
    };
}
