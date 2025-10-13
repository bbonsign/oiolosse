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
        "--style=full"
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
      # https://github.com/folke/tokyonight.nvim/blob/main/extras/fzf/tokyonight_night.sh
      colors = {
        # fg = "#c0caf5";
        # hl = "#bb9af7";
        # "fg+" = "#c0caf5";
        # "bg+" = "#1a1b26";
        # "hl+" = "#7dcfff";
        # info = "#7aa2f7";
        # prompt = "#7dcfff";
        # pointer = "#7dcfff";
        # marker = "#9ece6a";
        # spinner = "#9ece6a";
        # header = "#9ece6a";

        "bg+" = "#1a1b26";
        "bg" = "-1"; # Default terminal foreground/background color
        "border" = "#27a1b9";
        "fg" = "#c0caf5";
        "gutter" = "#16161e";
        "header" = "#ff9e64";
        "hl+" = "#2ac3de";
        "hl" = "#2ac3de";
        "info" = "#545c7e";
        "marker" = "#ff007c";
        "pointer" = "#ff007c";
        "prompt" = "#2ac3de";
        "query" = "#c0caf5:regular";
        "scrollbar" = "#27a1b9";
        "separator" = "#ff9e64";
        "spinner" = "#ff007c";
      };
    };
  };
}
