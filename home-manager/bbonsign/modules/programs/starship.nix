_:

{
  config = {
    programs.starship = {
      enable = true;
      settings = {
        add_newline = true;
        format =
          "$username$hostname$localip$singularity$kubernetes$directory$vcsh$fossil_branch$fossil_metrics$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$pijul_channel$docker_context$c$cmake$cobol$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$golang$guix_shell$haskell$haxe$helm$java$julia$kotlin$gradle$lua$nim$nodejs$ocaml$opa$perl$php$pulumi$purescript$python$raku$rlang$red$ruby$rust$scala$solidity$swift$terraform$typst$vlang$vagrant$zig$buf$nix_shell$conda$meson$spack$memory_usage$direnv$env_var$crystal$custom$sudo$fill$aws$azure$gcloud$container$shell$shlvl$cmd_duration$time$line_break$jobs$battery$status$os$character";
        aws = {
          symbol = " ";
          format = "[$symbol(|$profile)(|$region)(|$duration)]($style) ";
          region_aliases = {
            us-east-1 = "use1";
            us-east-2 = "use2";
            us-west-1 = "usw1";
            us-west-2 = "usw2";
          };
        };
        character = {
          success_symbol = "[λ](bold blue)";
          error_symbol = "[λ](bold red)";
        };
        container.style = "purple";
        docker_context.symbol = " ";
        elixir = {
          symbol = " ";
          style = "#5e3f9e";
        };
        elm.symbol = " ";
        fill.symbol = " ";
        # gcloud.disabled = true;
        git_branch.symbol = " ";
        golang.symbol = " ";
        haskell.symbol = " ";
        line_break.disabled = false;
        lua.symbol = " ";
        python.symbol = " ";
        rlang = {
          symbol = "  ";
          style = "blue bold";
        };
        rust.symbol = " ";
        shell.disabled = false;
        shlvl = {
          disabled = false;
          symbol = "";
          threshold = 2;
          format = "($shlvl) ";
        };
        time = {
          disabled = false;
          format = " [$time]($style) ";
          style = "blue";
        };
      };
    };
  };
}
