_: {
  config = {
    programs.zellig.enable = true;
    xdg.configFile."zellij" = { source = ./config.kdl; };
  };
}
