{pkgs, ...}: {
  config = {
    programs.nushell = {
      enable = true;
      plugins = [ pkgs.nushellPlugins.polars ];
      # remove the `ll` alias in favor os a nushell native ls alias in helpers.nu
      shellAliases = builtins.removeAttrs
        ((import ../shellAliases.nix) //
          (import ../shellAbbrs.nix) //
          {
            "h" = "help";
            ":h" = ":help";
            "jl" = "job list";
            "jf" = "job unfreeze";
            "jfg" = "job unfreeze";
          }) [ "ll" ];
      envFile.source = ./env.nu;
      configFile.source = ./config.nu;
      loginFile = {
        text = ''
          $env.EDITOR = "nvim"
          $env.NIX_PATH = "nixpkgs=flake:nixpkgs"
        '';
      };
    };
  };
}
