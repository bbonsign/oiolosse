{inputs, ...}:

{
  imports = [
    inputs.ignis.homeManagerModules.default
  ];

  config = {
    programs.ignis = {
      enable = true;
      # Add Ignis to the Python environment (useful for LSP support)
      addToPythonEnv = true;
      # Put a config directory from your flake into ~/.config/ignis
      # NOTE: Home Manager will copy this directory to /nix/store
      # and create a symbolic link to the copy.
      configDir = ../../../../dotfiles/ignis;
      # Enable dependencies required by certain services.
      # NOTE: This won't affect your NixOS system configuration.
      # For example, to use NetworkService, you must also enable
      # NetworkManager in your NixOS configuration:
      #   networking.networkmanager.enable = true;
      services = {
        bluetooth.enable = true;
        recorder.enable = true;
        audio.enable = true;
        network.enable = true;
      }; 
      # Enable Sass support
      sass = {
        enable = true;
        useDartSass = true;
      };
    };
  };
}

