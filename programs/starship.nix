{ ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format =
        "$username$hostname$localip$shlvl$singularity$kubernetes$directory$vcsh$fossil_branch$fossil_metrics$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$pijul_channel$docker_context$package$c$cmake$cobol$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$golang$guix_shell$haskell$haxe$helm$java$julia$kotlin$gradle$lua$nim$nodejs$ocaml$opa$perl$php$pulumi$purescript$python$raku$rlang$red$ruby$rust$scala$solidity$swift$terraform$typst$vlang$vagrant$zig$buf$nix_shell$conda$meson$spack$memory_usage$aws$gcloud$openstack$azure$direnv$env_var$crystal$custom$sudo$cmd_duration$fill$time$line_break$jobs$battery$status$os$container$shell$character";
      # right_format = "$time";

      line_break.disabled = false;
      aws.disabled = true;
      gcloud.disabled = true;
      time = {
        disabled = false;
        format = " [$time]($style) ";
        style = "blue";
      };

      character = {
        success_symbol = "[λ](bold blue)";
        error_symbol = "[λ](bold red)";
      };
      elixir = {
        symbol = " ";
        style = "#5e3f9e";
      };
      fill.symbol = " ";
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
