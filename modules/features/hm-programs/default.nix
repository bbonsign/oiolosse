{self, ...}:
{
  flake.homeModules.hm-programs = _:
    {
      imports = [
        self.homeModules.difftastic
        self.homeModules.fd
        self.homeModules.gammastep
        self.homeModules.gtk
        self.homeModules.kde-connect
        self.homeModules.keyd
        self.homeModules.mise
        self.homeModules.neovim
        self.homeModules.tmux
        self.homeModules.topiary
        self.homeModules.vicinae
        self.homeModules.wezterm
        self.homeModules.zathura
      ];
    };
}
