{ ... }:

{
  programs.wezterm.enable = true;
  home.file.".config/wezterm" = {
    source = ../dotfiles/dot_config/wezterm;
    recursive = true;
  };
}
