_:
{
  flake.homeModules.beam = {pkgs,...}: {

    config = {
      home.sessionVariables = {
        ERL_AFLAGS = "-kernel shell_history enabled";
      };
      home.packages = [
        pkgs.beam.packages.erlang_28.elixir_1_19
        pkgs.beam.packages.erlang_28.erlang
      ];
    };
  };
}

