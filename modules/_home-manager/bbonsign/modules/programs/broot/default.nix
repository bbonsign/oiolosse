_:

{
  config = {
    programs.broot = {
      enable = false;
      settings = {
        imports = [ "verbs.hjson" { file = "skins/catppuccin-mocha.hjson"; luma = [ "dark" "unknown" ]; } ];
        # enable_kitty_keyboard = true;
        icon_theme = "nerdfont";
        modal = true;
        show_selection_mark = true;
        syntax_theme = "GitHub";
      };
    };
  };
}
