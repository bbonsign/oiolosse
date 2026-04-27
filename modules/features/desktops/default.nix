{self, ...}:
{
  flake.homeModules.desktops = _:
    {
      imports = [
        # self.homeModules.gnome
        self.homeModules.dconf
        self.homeModules.noctalia
        self.homeModules.niri
        # self.homeModules.sway
      ];
    };
}
