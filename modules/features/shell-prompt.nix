{self, ...}:
{
  flake.homeModules.shell-prompt = {pkgs,...}: {
    programs.starship = {
      enable = true;
      package = self.packages.x86_64-linux.starship;
    };
    home.packages = [
      pkgs.nerd-fonts.fira-code
    ];
  };
}

