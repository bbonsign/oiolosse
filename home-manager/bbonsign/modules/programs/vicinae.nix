{ config, ... }:

{
  config = {
    programs.vicinae = {
      enable = true;
      systemd.enable = true;
    };
  };
}
