_: {
  config = {
    programs.atuin = {
      enable = true;
      flags = [
        "--disable-up-arrow"
        # "--disable-ctrl-r"
      ];
      settings = {
        enter_accept = false;
        # Use Ctrl-0 .. Ctrl-9 instead of Alt-0 .. Alt-9 UI shortcuts
        ctrl_n_shortcuts = true;
        keymap_mode = "vim-insert";
        keymap_cursor = {
          emacs = "blink-block";
          vim_insert = "blink-block";
          vim_normal = "steady-block";
        };
      };
    };
  };
}
