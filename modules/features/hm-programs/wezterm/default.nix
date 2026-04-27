_:
{
  flake.homeModules.wezterm = _:
    {
      config = {
        programs.wezterm.enable = false;
        xdg.configFile."wezterm" = {
          source = ./.;
          recursive = true;
        };
      };
    };
}
