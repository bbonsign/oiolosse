_:
{
  flake.homeModules.kde-connect = _:
    {
      config = {
        services.kdeconnect.enable = false;
        services.kdeconnect.indicator = false;
      };
    };
}
