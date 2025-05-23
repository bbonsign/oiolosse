_:

{
  config = {
    programs.fzf = {
      enable = true;
      defaultCommand =
        "fd --color always --follow --ignore-file '$HOME/.config/fd/ignore'";
      fileWidgetCommand = "fd --color always --follow --ignore-file '$HOME/.config/fd/ignore'";
      defaultOptions = [
        "--ansi"
        "--cycle"
        "--layout=reverse"
        "--height=70%"
        "--pointer='┃'"
        "--prompt=' '"
        "--preview-window=right:65%"
        "--bind=ctrl-b:preview-up"
        "--bind=ctrl-f:preview-down"
        "--bind=ctrl-space:toggle-preview"
      ];
      tmux.enableShellIntegration = true;
      #
      # tokyonight colors
      colors = {
        fg = "#c0caf5";
        bg = "-1"; # Default terminal foreground/background color
        hl = "#bb9af7";
        "fg+" = "#c0caf5";
        "bg+" = "#1a1b26";
        "hl+" = "#7dcfff";
        info = "#7aa2f7";
        prompt = "#7dcfff";
        pointer = "#7dcfff";
        marker = "#9ece6a";
        spinner = "#9ece6a";
        header = "#9ece6a";
      };
    };
  };
}
