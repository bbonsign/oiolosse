{ pkgs, ... }: {
  config = {

    # home.packages = [
    #   pkgs.smug # tmux session manager
    # ];
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      escapeTime = 0;
      historyLimit = 1000000;
      mouse = true;
      newSession = true;
      prefix = "C-Space";
      sensibleOnTop = true;
      # shell = "${pkgs.fish}/bin/fish";
      shell = "${pkgs.nushell}/bin/nu";
      terminal = "tmux-256color";
      extraConfig = builtins.readFile ./tmux.conf;

      plugins = with pkgs; [
        tmuxPlugins.sensible

        {
          plugin = tmuxPlugins.fuzzback;
          extraConfig = ''
            set -g @fuzzback-table tableSearch
            set -g @fuzzback-bind /
          '';
        }

        { plugin = tmuxPlugins.tmux-fzf; }

        {
          plugin = tmuxPlugins.yank;
          extraConfig = ''
            # Don't exit copy mode on yank. 'copy-pipe-and-cancel' for the default
            set -g @yank_action 'copy-pipe'
          '';
        }

        {
          # Bound to prefix-u by default
          plugin = tmuxPlugins.fzf-tmux-url;
          extraConfig = ''
            set -g @fzf-url-bind 'U'
            set -g @fzf-url-fzf-options '-p 60%,30% --prompt="   " --border-label=" Open URL " --bind "ctrl-y:execute-silent(echo -n {2} | wl-copy)"'
            set -g @fzf-url-history-limit '2000'
          '';
        }

        { plugin = tmuxPlugins.yank; }

        { plugin = tmuxPlugins.prefix-highlight; }

        {
          plugin = tmuxPlugins.tmux-floax;
          extraConfig = ''
            set -g @floax-bind '-n M-p'
            # set -g @floax-change-path 'false'
            set -g @floax-session-name 'floax'
            set -g @floax-text-color 'white'
          '';
        }

        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-processes     'lazygit man nvim'
            set -g @resurrect-strategy-nvim 'session'
          '';
        }

        {
          plugin = tmuxPlugins.continuum;
          extraConfig = "set -g @continuum-restore 'on'";
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
      ];
    };
  };
}
