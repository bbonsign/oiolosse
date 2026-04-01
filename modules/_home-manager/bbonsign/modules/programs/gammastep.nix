_:
{
  config =
    {
      services.gammastep = {
        enable = true;
        provider = "manual";
        latitude = 35.0;
        longitude = -78.0;
        # temperature = {
        #   day = 5000;
        #   night = 4000;
        # };
        # https://gitlab.com/chinstrap/gammastep/-/blob/master/gammastep.conf.sample
        settings = {
          general.adjustment-method = "wayland";
        };
        tray = true;
      };
    };
}

