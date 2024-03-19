{ pkgs, tmux-sessionx, ... }:

{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 1000000;
    mouse = true;
    newSession = true;
    prefix = "C-Space";
    sensibleOnTop = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";
    extraConfig = builtins.readFile ./tmux.conf;

    plugins = with pkgs; [
      tmuxPlugins.sensible

      {
        plugin = tmux-sessionx.packages.${pkgs.system}.default;
        extraConfig = ''
          set -g @sessionx-bind 'o'
          # set -g @sessionx-x-path '~/dotfiles'
          set -g @sessionx-window-height '85%'
          set -g @sessionx-window-width '75%'
          # set -g @sessionx-zoxide-mode 'on'
          set -g @sessionx-filter-current 'false'
          set -g @sessionx-preview-enabled 'true'
        '';
      }

      {
        plugin = tmuxPlugins.fuzzback;
        extraConfig = ''
          set -g @fuzzback-table tableSearch
          set -g @fuzzback-bind /
        '';
      }

      { plugin = tmuxPlugins.tmux-fzf; }

      { plugin = tmuxPlugins.yank; }

      {
        # Bound to prefix-u be default
        plugin = tmuxPlugins.fzf-tmux-url;
        extraConfig = ''
          set -g @fzf-url-fzf-options '-p 60%,30% --prompt="   " --border-label=" Open URL "'
          set -g @fzf-url-history-limit '2000'
        '';
      }

      { plugin = tmuxPlugins.yank; }

      { plugin = tmuxPlugins.prefix-highlight; }

      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }

      {
        plugin = tmuxPlugins.continuum;
        extraConfig = "set -g @continuum-restore 'on'";
      }

      # {
      #   plugin = tmuxPlugins.catppuccin;
      #   extraConfig = ''
      #     set -g @catppuccin_window_left_separator ""
      #     set -g @catppuccin_window_right_separator " "
      #     set -g @catppuccin_window_middle_separator "█ "
      #     set -g @catppuccin_window_number_position "left"
      #     set -g @catppuccin_window_default_fill "number"
      #     set -g @catppuccin_window_default_text "#W"
      #     set -g @catppuccin_window_current_fill "number"
      #     set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,  ,}"
      #     set -g @catppuccin_status_modules_right "directory date_time"
      #     set -g @catppuccin_status_modules_left "session"
      #     set -g @catppuccin_status_left_separator  " "
      #     set -g @catppuccin_status_right_separator " "
      #     set -g @catppuccin_status_right_separator_inverse "no"
      #     set -g @catppuccin_status_fill "icon"
      #     set -g @catppuccin_status_connect_separator "no"
      #     set -g @catppuccin_directory_text "#{b:pane_current_path}"
      #     set -g @catppuccin_date_time_text "%H:%M"
      #
      #     set -g @catppuccin_icon_window_last "󰖰"
      #     set -g @catppuccin_icon_window_current ""
      #     set -g @catppuccin_icon_window_zoom "󰁌 "
      #     set -g @catppuccin_icon_window_mark "󰃀"
      #     set -g @catppuccin_icon_window_silent "󰂛 "
      #     set -g @catppuccin_icon_window_activity "󰂞 "
      #     set -g @catppuccin_icon_window_bell "󰂞 "
      #   '';
      # }

      # {
      #   plugin = tmuxPlugins.mkTmuxPlugin {
      #     pluginName = "tmux-sessionx";
      #     version = "0.1";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "omerxx";
      #       repo = "tmux-sessionx";
      #       rev = "e39372ad2a275d73b1680483608c4dbac5c1a219";
      #       sha256 = "sha256-daV8D6d7JmjroYA7CBEjWGNu1KDCWafVGeYrLh8FAsg=";
      #     };
      #   };
      # }

    ];
  };
}
