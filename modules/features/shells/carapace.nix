_:
{
  flake.homeModules.carapace = {pkgs, ...}:
    {
      config = {
        home.packages = [
          pkgs.carapace-bridge
        ];

        programs.carapace = {
          enable = true;
          enableFishIntegration = true;
          enableNushellIntegration = true;
        };
      };
    };
}
