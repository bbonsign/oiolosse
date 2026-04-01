_:

{
  config = {
    programs.vicinae = {
      enable = true;
    };

    systemd.user.services.vicinae = {
      Unit = {
        Description = "Vicinae";
        PartOf = "graphical-session.target";
        Requisite = "graphical-session.target";
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "%h/.nix-profile/bin/nixGL vicinae server";
        Restart = "on-failure";
        RestartSec = 1;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
