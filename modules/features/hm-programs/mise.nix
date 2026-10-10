_: {
  flake.homeModules.mise = { lib, ... }: {
    config = {
      programs.mise = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
      };

      # Temporary: runtime activation still restores a parent's stale original
      # PATH in nested shells. Reset inherited state before upstream activation.
      programs.nushell.extraEnv = lib.mkBefore ''
        hide-env --ignore-errors MISE_SHELL __MISE_DIFF __MISE_SESSION __MISE_ORIG_PATH __MISE_EXE
      '';
    };
  };
}
