{ pkgs, ... }: {
  config = {
    programs.nushell = {
      enable = true;
      plugins = [
        pkgs.nushellPlugins.gstat
        pkgs.nushellPlugins.query
        pkgs.nushellPlugins.polars
      ];
      # remove the `ll` alias in favor os a nushell native ls alias in helpers.nu
      shellAliases = builtins.removeAttrs
        ((import ../shellAliases.nix) //
          (import ../shellAbbrs.nix) //
          {
            "h" = "help";
            ":h" = ":help";
            cleancontainers = "docker rm -v ...(docker ps -a -q -f status=exited | lines)";
            cleanimages = "docker rmi ...(docker images -q -f dangling=true | lines)";
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
