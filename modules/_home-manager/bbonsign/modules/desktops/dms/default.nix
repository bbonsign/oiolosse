{ inputs, ... }:
{
  imports = [
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
  ];

  config = {
    programs.dankMaterialShell = {
      enable = true;
      # quickshell.package = inputs.quickshell.packages.${system}.default;

      systemd = {
        enable = false; # Systemd service for auto-start
        restartIfChanged = true; # Auto-restart dms.service when dankMaterialShell changes
      };

      # Core features
      enableSystemMonitoring = true; # System monitoring widgets (dgop)
      enableVPN = true; # VPN management widget
      enableDynamicTheming = false; # Wallpaper-based theming (matugen)
    };

    # systemd.user.services.dms = {
    #   Unit = {
    #     Description = "DankMaterialShell";
    #     PartOf = [ config.wayland.systemd.target ];
    #     After = [ config.wayland.systemd.target ];
    #   };
    #
    #   Service = {
    #     ExecStart = "%h/.nix-profile/bin/nixGL dms run --session";
    #     Restart = "on-failure";
    #   };
    #
    #   Install.WantedBy = [ config.wayland.systemd.target ];
    # };

  };

}
