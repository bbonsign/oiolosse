{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    shellAliases = import ./shellAliases.nix;
    shellAbbrs = import ./shellAbbrs.nix;

    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      source ~/.config/fish/colors/fish_tokyonight_night.fish

      # bgcolor of the current tab completion selection
      set fish_color_search_match --background=4b719c

      set -gx PATH "$HOME/.cargo/bin" $PATH
      set -gx PATH "$HOME/go/bin" $PATH

      fzf_configure_bindings
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
}
