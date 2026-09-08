_: {
  flake.homeModules.vicinae = { config, ... }: {
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
          ExecStart = "${config.programs.vicinae.package}/bin/vicinae server";
          Restart = "on-failure";
          RestartSec = 1;
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
  };
}
