_:
{
  flake.homeModules.difftastic = _:
    {
      config = {
        programs.difftastic = {
          enable = false;
          options = {
            display = "side-by-side";
          };
        };
      };
    };
}
