{ pkgs, ... }:

{
  programs.fzf = {
    enable = true;

    # --bind=ctrl-u:preview-up,ctrl-d:preview-down,ctrl-space:toggle-preview
    colors = {
      fg = "#c0caf5";
      bg = "#1a1b26";
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
}

