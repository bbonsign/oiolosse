{ inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  config = {
    programs.noctalia-shell = {
      enable = true;
    };

    systemd.user.services.noctalia-service = {
      Unit = {
        Description = "Noctalia Shell Service";
        PartOf = "graphical-session.target";
        Requisite = "graphical-session.target";
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "%h/.nix-profile/bin/nixGL noctalia-shell";
        Restart = "on-failure";
        RestartSec = 1;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };

}
