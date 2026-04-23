_:
{
  flake.homeModules.bash = {...}:
    {
      config = {
        programs.bash = {
          enable = true;
          enableCompletion = true;

          # shellAliases = import ./_shellAliases.nix;
          sessionVariables = {
            MANPAGER = "nvim +Man!";
            EDITOR = "nvim";
            VISUAL = "nvim";
            FZF_COMPLETION_TRIGGER = "";
          };
        };
      };
    };
}
