_:
{
  flake.homeModules.cursor = {pkgs,...}: {

    config = {
      home.pointerCursor = {
        enable = true;
        gtk.enable = true;
        package = pkgs.nordzy-cursor-theme;
        name = "Nordzy-cursors";
        size = 24;
      };
    };
  };
}

