{inputs, system, ...}: 
{
  imports = [
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
  ];

  config = {
    programs.dankMaterialShell = {
      enable = false;
      quickshell.package = inputs.quickshell.packages.${system}.default;

      systemd = {
        enable = false;             # Systemd service for auto-start
        restartIfChanged = true;   # Auto-restart dms.service when dankMaterialShell changes
      };

      # Core features
      enableSystemMonitoring = true;     # System monitoring widgets (dgop)
      enableClipboard = true;            # Clipboard history manager
      enableVPN = true;                  # VPN management widget
      enableBrightnessControl = true;    # Backlight/brightness controls
      enableColorPicker = true;          # Color picker tool
      enableDynamicTheming = false;      # Wallpaper-based theming (matugen)
    };
  };
}
