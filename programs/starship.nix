{ ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      line_break.disabled = false;
      aws.disabled = true;
      gcloud.disabled = true;

      character = {
        success_symbol = "[λ](bold blue)";
        error_symbol = "[λ](bold red)";
      };
      elixir = {
        symbol = " ";
        style = "#5e3f9e";
      };
      haskell.symbol = " ";
      lua.symbol = " ";
      python.symbol = " ";
      docker_context.symbol = " ";
      elm.symbol = " ";
      git_branch.symbol = " ";
      golang.symbol = " ";
      rust.symbol = " ";
    };
  };
}
