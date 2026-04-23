_:
{
  flake.homeModules.carapace = {...}:
    {
      config = {
        programs.carapace = {
          enable = true;
          enableFishIntegration = true;
          enableNushellIntegration = true;
        };
      };
    };
}
