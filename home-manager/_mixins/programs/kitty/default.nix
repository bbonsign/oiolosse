_: {
  config = {
    home.file.".config/kitty/tab_bar.py".source = ./tab_bar.py;
    home.file.".config/kitty/open-actions.conf".source = ./open-actions.conf;

    programs.kitty = {
      enable = true;
      theme = "Tokyo Night";
      font = {
        name = "FiraCode Nerd Font";
        size = 12.0;
      };
      settings = {
        adjust_line_height = "90%";
        window_padding_width = 2;
        hide_window_decorations = "yes";
        background_opacity = ".75";
        background_tint = "0.4";
        dynamic_background_opacity = "no";
        enable_audio_bell = "no";
        enabled_layouts = "tall, fat, stack, splits";
        inactive_text_alpha = "0.55";

        # shell = "nu";

        tab_bar_edge = "top";
        tab_bar_style = "custom";
        tab_title_template = ''
          {index} {title}{f" [{num_windows}]" if num_windows>1 and layout_name=="stack" else ""}
        '';

        editor = "nvim";
        macos_option_as_alt = "both";
        macos_quit_when_last_window_closed = "yes";

        confirm_os_window_close = 1;
      };
      keybindings = {
        "ctrl+x>ctrl+x" = "send_text all u0018";
        "ctrl+c" = " copy_or_interrupt";
        "kitty_mod+v" = " paste_from_clipboard";

        "ctrl+x>w>r" = "          start_resizing_window";
        "ctrl+x>ctrl+w>ctrl+r" = "start_resizing_window";
        "ctrl+x>return" = "     launch --cwd current";
        "ctrl+x>ctrl+return" = "launch --cwd current";
        "ctrl+x>v" = "          launch --location=vsplit";

        "ctrl+x>h" = "     neighboring_window left";
        "ctrl+x>j" = "     neighboring_window down";
        "ctrl+x>k" = "     neighboring_window up";
        "ctrl+x>l" = "     neighboring_window right";
        "ctrl+x>ctrl+h" = "neighboring_window left";
        "ctrl+x>ctrl+j" = "neighboring_window down";
        "ctrl+x>ctrl+k" = "neighboring_window up";
        "ctrl+x>ctrl+l" = "neighboring_window right";

        "ctrl+x>shift+h" = "move_window left";
        "ctrl+x>shift+j" = "move_window down";
        "ctrl+x>shift+k" = "move_window up";
        "ctrl+x>shift+l" = "move_window right";
        "ctrl+x>[" = "      previous_tab";
        "ctrl+x>ctrl+[" = " previous_tab";
        "ctrl+x>]" = "      next_tab";
        "ctrl+x>ctrl+]" = " next_tab";

        "ctrl+x>t" = "         new_tab";
        "ctrl+x>ctrl+t" = "    new_tab";
        "ctrl+x>}" = "     move_tab_forward";
        "ctrl+x>{" = "     move_tab_backward";

        "ctrl+x>r" = "       set_tab_title";
        "ctrl+x>tab>r" = "   set_tab_title";

        "ctrl+x>tab>s" = "select_tab";

        "ctrl+x>1" = "goto_tab 1";
        "ctrl+x>2" = "goto_tab 2";
        "ctrl+x>3" = "goto_tab 3";
        "ctrl+x>4" = "goto_tab 4";
        "ctrl+x>5" = "goto_tab 5";
        "ctrl+x>6" = "goto_tab 6";
        "ctrl+x>7" = "goto_tab 7";
        "ctrl+x>8" = "goto_tab 8";
        "ctrl+x>9" = "goto_tab 9";

        "ctrl+x>tab>1" = "goto_tab 1";
        "ctrl+x>tab>2" = "goto_tab 2";
        "ctrl+x>tab>3" = "goto_tab 3";
        "ctrl+x>tab>4" = "goto_tab 4";
        "ctrl+x>tab>5" = "goto_tab 5";
        "ctrl+x>tab>6" = "goto_tab 6";
        "ctrl+x>tab>7" = "goto_tab 7";
        "ctrl+x>tab>8" = "goto_tab 8";
        "ctrl+x>tab>9" = "goto_tab 9";

        "ctrl+x>space>space" = "next_layout";
        "ctrl+x>z" = "goto_layout stack";
        "ctrl+x>ctrl+z" = "last_used_layout";
        "ctrl+x>space>z" = "goto_layout stack";
        "ctrl+x>ctrl+space>ctrl+z" = "last_used_layout";
        "ctrl+x>space>s" = "goto_layout stack";
        "ctrl+x>space>v" = "goto_layout tall";
        "ctrl+x>space>h" = "goto_layout fat";
        "ctrl+x>space>g" = "goto_layout grid";
        "ctrl+x>space>a" = "goto_layout splits";
        "ctrl+x>space>p" = "last_used_layout";
        "ctrl+x>space>t" = "last_used_layout";
        "ctrl+x>space>backspace" = "last_used_layout";

        "ctrl+x>/>u" = "kitten hints";

        "ctrl+x>/>f" = "kitten hints --type path --program -";
        "ctrl+x>/>/" = "kitten hints --type path --program -";

        "ctrl+x>/>o" = "kitten hints --type path --program -";
        "ctrl+x>/>l" = "kitten hints --type line --program -";

        "ctrl+x>/>w" = "kitten hints --type word --program -";

        "ctrl+x>/>h" = "kitten hints --type hash --program -";

        "ctrl+x>/>n" =
          "kitten hints --type=linenum --linenum-action=self /usr/local/bin/nvim +{line} {path}";

        "kitty_mod+escape" = "kitty_shell window";
        "ctrl+x>backspace" = "kitty_shell window";
      };
    };
  };
}
