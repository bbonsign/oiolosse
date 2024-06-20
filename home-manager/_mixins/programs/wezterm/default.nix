_: {
  config = {
    programs.wezterm.enable = true;
    xdg.configFile."wezterm" = {
      source = ./.;
      recursive = true;
    };
  };
}
