_:
{
  flake.homeModules.keyboard = {pkgs,...}:
    {
      config = {
      };
    };

  flake.nixosModules.keyboard = {pkgs,...}:
    {
      config = {
        # Configure keymap in X11
        services.xserver.xkb = {
          layout = "us";
          variant = "";
          options = "ctrl:no_caps";
        };
      };
    };
}

