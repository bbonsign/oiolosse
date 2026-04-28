_:
{
  flake.homeModules.boot = {pkgs,...}:
    {
      config = {
      };
    };

  flake.nixosModules.boot = {pkgs,...}:
    {
      config = {
        # Bootloader.
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
      };
    };
}

