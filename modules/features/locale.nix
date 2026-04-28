_:
{
  flake.homeModules.locale = {pkgs,...}:
    {
      config = {
      };
    };

  flake.nixosModules.locale = {pkgs,...}:
    {
      config = {
        time.timeZone = "America/New_York";

        # Select internationalisation properties.
        i18n.defaultLocale = "en_US.UTF-8";
        i18n.extraLocaleSettings = {
          LC_ADDRESS = "en_US.UTF-8";
          LC_IDENTIFICATION = "en_US.UTF-8";
          LC_MEASUREMENT = "en_US.UTF-8";
          LC_MONETARY = "en_US.UTF-8";
          LC_NAME = "en_US.UTF-8";
          LC_NUMERIC = "en_US.UTF-8";
          LC_PAPER = "en_US.UTF-8";
          LC_TELEPHONE = "en_US.UTF-8";
          LC_TIME = "en_US.UTF-8";
        };

        # Enable touchpad support (enabled default in most desktopManager).
        services.libinput.enable = true;
      };
    };
}

