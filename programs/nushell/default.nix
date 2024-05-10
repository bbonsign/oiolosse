{ pkgs, ... }: {
  home.packages = [ pkgs.fish ];

  programs.nushell = {
    enable = true;
    shellAliases = (import ../shellAliases.nix) // (import ../shellAbbrs.nix);
    envFile.source = ./env.nu;
    configFile.source = ./config.nu;
    loginFile = {
      text = ''
        $env.EDITOR = "nvim"
        $env.NIX_PATH = "nixpkgs=flake:nixpkgs"
      '';
    };
  };
}
