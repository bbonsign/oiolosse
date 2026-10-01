_: {
  flake.homeModules.mise =
    { lib, pkgs, ... }:
    {
      config = {
        programs.mise = {
          enable = true;
          enableBashIntegration = true;
          enableFishIntegration = true;
          enableNushellIntegration = false;
          enableZshIntegration = true;
        };

        # Temporary workaround: Home Manager generates the Nushell module in its
        # Nix build sandbox, causing mise to embed the sandbox PATH. Remove this
        # and re-enable the integration once Home Manager generates it at runtime.
        programs.nushell.extraEnv = lib.mkAfter ''
          let mise_path = $nu.default-config-dir | path join mise.nu
          # Prevent nested shells from restoring an inherited, stale original PATH.
          hide-env --ignore-errors MISE_SHELL __MISE_DIFF __MISE_SESSION __MISE_ORIG_PATH __MISE_EXE
          ^${lib.getExe pkgs.mise} activate nu | save $mise_path --force
        '';
        programs.nushell.extraConfig = lib.mkAfter ''
          use ($nu.default-config-dir | path join mise.nu)
        '';
      };
    };
}
