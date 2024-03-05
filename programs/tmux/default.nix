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
    extraConfig = ''
      # set-option -g default-terminal 'screen-254color'
      set-option -g terminal-overrides ',xterm-256color:RGB'
      set-option -ga terminal-features ',xterm-kitty:RGB'

      # unbind C-Space
      # set -g prefix C-Space
      # bind C-Space send-prefix         # Send command on double press
      set -g detach-on-destroy off     # don't exit from tmux when closing a session
      set -g history-limit 1000000     # increase history size (from 2,000)
      set -g renumber-windows on       # renumber all windows when any window is closed
      set -g set-clipboard on          # use system clipboard
      set -g status-position top
      setw -g mode-keys vi
      set -g pane-active-border-style 'fg=magenta,bg=default'
      set -g pane-border-style 'fg=brightblack,bg=default'


      # Copy-mode
      unbind-key -T copy-mode-vi v
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi 'C-v' send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "wl-copy"

      # Reload tmux.conf on prefix r
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

      # Split panes and remember current path
      bind v split-window -h -c '#{pane_current_path}'
      bind s split-window -v -c '#{pane_current_path}'

      # Remember current path when creating new windows
      bind c new-window #-c '#{pane_current_path}'

      # Prefix+s shows session list by default, but is shadowed by my split screen
      # biding, so use a instead
      bind a choose-tree -s

      bind 'h' select-pane -L
      bind 'j' select-pane -D
      bind 'k' select-pane -U
      bind 'l' select-pane -R
      bind 'C-h' select-pane -L
      bind 'C-j' select-pane -D
      bind 'C-k' select-pane -U
      bind 'C-l' select-pane -R

      bind 'V' copy-mode

      bind ']' next-window
      bind '[' previous-window

      # bind 'C-f' command-prompt -I "#W" "rename-window -- '%%'"
      # bind ',' display-popup -E "fish -c tmuz-switch-session"
      # bind '?' display-popup -h 90% -w 90% -E "fish -c tmuz-list-keys"

      # Toggle status bar
      bind-key -r t set-option -g status

      # Break pane into new window and keep focus on the current window
      bind b break-pane -d

      # Undercurl for errors in vim etc
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0
    '';

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

      { plugin = tmuxPlugins.tmux-fzf; }

      {
        plugin = tmuxPlugins.fzf-tmux-url;
        extraConfig = ''
          set -g @fzf-url-fzf-options '-p 60%,30% --prompt="   " --border-label=" Open URL "'
          set -g @fzf-url-history-limit '2000'
        '';
      }

      { plugin = tmuxPlugins.yank; }

      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }

      {
        plugin = tmuxPlugins.continuum;
        extraConfig = "set -g @continuum-restore 'on'";
      }

      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator " "
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
          set -g @catppuccin_status_modules_right "directory meetings date_time"
          set -g @catppuccin_status_modules_left "session"
          set -g @catppuccin_status_left_separator  " "
          set -g @catppuccin_status_right_separator " "
          set -g @catppuccin_status_right_separator_inverse "no"
          set -g @catppuccin_status_fill "icon"
          set -g @catppuccin_status_connect_separator "no"
          set -g @catppuccin_directory_text "#{b:pane_current_path}"
          set -g @catppuccin_meetings_text "#($HOME/.config/tmux/scripts/cal.sh)"
          set -g @catppuccin_date_time_text "%H:%M"
        '';
      }

    ];
  };
}
