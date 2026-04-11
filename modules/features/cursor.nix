_:
{
  flake.homeModules.cursor = {pkgs,...}: {

    config = {
      home.pointerCursor = {
        gtk.enable = true;
        package = pkgs.nordzy-cursor-theme;
        name = "Nordzy-cursors";
        size = 24;
      };
    };
  };
}

