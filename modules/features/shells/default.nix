{self, ...}:
{
  flake.homeModules.shells = _:
    {
      imports = [
        self.homeModules.atuin
        self.homeModules.bash
        self.homeModules.carapace
        self.homeModules.direnv
        self.homeModules.fish
        self.homeModules.fzf
        self.homeModules.nushell
        self.homeModules.zoxide
        self.homeModules.zsh
      ];

      config = {
        home.shellAliases = import ./_shellAliases.nix;
      };
    };
}
