_: {
  config = {
    programs.nushell = {
      enable = true;
      shellAliases = (import ../shellAliases.nix) // (import ../shellAbbrs.nix) // { "h" = "help"; ":h" = ":help"; };
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
