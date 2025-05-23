{ pkgs, ... }: {
  config = {

    home.file.".config/fish/colors/fish_tokyonight_night.fish".source =
      ./fish_tokyonight_night.fish;

    programs.fish = {
      enable = true;

      shellAliases = import ../shellAliases.nix;
      shellAbbrs = import ../shellAbbrs.nix // {
        ":dev" = "export AWS_PROFILE=dev_qlair";
        ":euprod" = "export AWS_PROFILE=prod_qlair_eu";
        ":loc" = "export AWS_PROFILE=local";
        ":prod" = "export AWS_PROFILE=prod_qlair";
        ":sand" = "export AWS_PROFILE=sandbox";
      };

      interactiveShellInit = ''
        set fish_greeting # Disable greeting
        source ~/.config/fish/colors/fish_tokyonight_night.fish

        function jwt-decode
           echo  $argv[1] |    jq -R 'split(".") |.[0:2] | map(@base64d) | map(fromjson)'
        end

        function _to_qf --description 'start nvim with current command output as quick-fix list'
            set -l cmd (commandline)
            commandline -r "nvim -q ($cmd | psub)"
        end

        bind \cq _to_qf

        # bgcolor of the current tab completion selection
        set fish_color_search_match --background=4b719c

        set -gx PATH $PATH "$HOME/.cargo/bin" 
        set -gx PATH $PATH "$HOME/go/bin"
        set -gx PATH "$HOME/.local/bin" $PATH
        set -gx PATH "$HOME/.mix/escripts" $PATH

        set -gx MANPAGER "nvim +Man!"
        set -gx EDITOR "nvim"
        set -gx VISUAL "nvim"

        set -gx ERL_AFLAGS "-kernel shell_history enabled -kernel shell_history_file_bytes 1024000"

        set -gx fzf_preview_dir_cmd 'eza --long --all --color=always'

        fzf_configure_bindings --history=
        bind --erase \cr

        # disable built-in binding for appending pipe into less
        bind --erase --preset  \ep

        # open commandline in $EDITOR
        bind \co edit_command_buffer

        if command -v ruff 1>/dev/null 2>&1
            ruff generate-shell-completion fish | source
        end
      '';

      plugins = [{
        name = "fzf";
        src = pkgs.fetchFromGitHub {
          owner = "oddlama";
          repo = "fzf.fish";
          rev = "6331eedaf680323dd5a2e2f7fba37a1bc89d6564";
          sha256 = "sha256-BO+KFvHdbBz7SRA6EuOk2dEC8zORsCH9V04dHhJ6gxw=";
        };
      }];
    };
  };
}
