{ pkgs, ... }: {
  home.packages = [ pkgs.fish ];

  programs.nushell = {
    enable = true;
    shellAliases = import ./shellAliases.nix;
    envFile = {
      text = ''
        let fish_completer = {|spans|
          fish --command $'complete "--do-complete=($spans | str join " ")"'
          | $"value(char tab)description(char newline)" + $in
          | from tsv --flexible --no-infer
        }
        let external_completer = {|spans|
          let expanded_alias = scope aliases
            | where name == $spans.0
            | get -i 0.expansion

          let spans = if $expanded_alias != null {
              $spans
              | skip 1
              | prepend ($expanded_alias | split row ' ')
          } else {
              $spans
          }

          match $spans.0 {
              _ => $fish_completer
          } | do $in $spans
        }
        $env.PATH = ($env.PATH | split row (char esep) | append '$env.HOME/.nix-profile/bin')
        $env.PATH = ($env.PATH | split row (char esep) | append '/etc/profiles/per-user/$env.USER/bin')
        $env.PATH = ($env.PATH | split row (char esep) | append '/run/current-system/sw/bin')
        $env.PATH = ($env.PATH | split row (char esep) | append '/nix/var/nix/profiles/default/bin')
        $env.config = {
          show_banner: false,
          completions: {
              external: {
                  enable: true
                  completer: $external_completer
              }
          },
          cursor_shape: {
            emacs: inherit # block, underscore, line (line is the default)
            vi_insert: inherit # block, underscore, line (block is the default)
            vi_normal: inherit # block, underscore, line  (underscore is the default)
          }
        };
        def dockill [] {
          docker ps -aq | str trim |  split row "\n" | each { |it| docker rm -f $it }
        }
        $env.NIXPKGS_ALLOW_UNFREE = 1
      '';
    };
    loginFile = {
      text = ''
        $env.EDITOR = "nvim"
        $env.NIX_PATH = "nixpkgs=flake:nixpkgs"
      '';
    };
  };
}
