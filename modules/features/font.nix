{pkgs, ...}:
{
  flake.homeModules.font = {pkgs,...}: {
    fonts.fontconfig.enable = true;
    home.packages = [
      pkgs.nerd-fonts.fira-code
      pkgs.nerd-fonts.fantasque-sans-mono
    ];
  };
}

