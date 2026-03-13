{ pkgs, ... }: {
  config = {

    home.packages = [
      # pkgs.sesh # tmux session manager
    ];
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      escapeTime = 0;
      historyLimit = 1000000;
      mouse = true;
      newSession = true;
      prefix = "C-x";
      sensibleOnTop = true;
      # shell = "${pkgs.fish}/bin/fish";
      shell = "${pkgs.nushell}/bin/nu";
      terminal = "tmux-256color";
      extraConfig = builtins.readFile ./tmux.conf;

      plugins = with pkgs; [
        tmuxPlugins.sensible

        { plugin = tmuxPlugins.prefix-highlight; }
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

        # {
        #   plugin = tmuxPlugins.resurrect;
        #   extraConfig = ''
        #     set -g @resurrect-processes     'lazygit man nvim'
        #     set -g @resurrect-strategy-nvim 'session'
        #   '';
        # }

        # {
        #   plugin = tmuxPlugins.continuum;
        #   extraConfig = "set -g @continuum-restore 'off'";
        # }
      ];
    };
  };
}
