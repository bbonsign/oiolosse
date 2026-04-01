_: {
  config = {
    programs.wezterm.enable = false;
    xdg.configFile."wezterm" = {
      source = ./.;
      recursive = true;
    };
  };
}
