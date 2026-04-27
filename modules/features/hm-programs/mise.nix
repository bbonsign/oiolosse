_:
{
  flake.homeModules.mise = _:
    {
      config = {
        programs.mise = {
          enable = true;
          enableBashIntegration = true;
          enableFishIntegration = true;
          enableNushellIntegration = true;
          enableZshIntegration = true;
        };
      };
    };
}
