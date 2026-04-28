_:
{
  flake.homeModules.font = {pkgs,...}:
    {
      config = {
        fonts.fontconfig.enable = true;
        home.packages = [
          pkgs.nerd-fonts.fira-code
          pkgs.nerd-fonts.fantasque-sans-mono
        ];
      };
    };

  flake.nixosModules.font = {pkgs,...}:
    {
      config = {
        fontspackages = [
          pkgs.nerd-fonts.fira-code
          pkgs.nerd-fonts.fantasque-sans-mono
        ];
      };
    };
}

