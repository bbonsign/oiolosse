_: {
  config = {
    programs.nushell = {
      enable = true;
      # remove the `l` alias in favor os a nushell native ls alias in helpers.nu
      shellAliases = builtins.removeAttrs
        ((import ../shellAliases.nix) //
          (import ../shellAbbrs.nix) //
          {
            "h" = "help";
            ":h" = ":help";
          }) [ "l" ];
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
