{ pkgs, ... }:
{
  config = {
    environment.systemPackages = [
      pkgs.bazecor
    ];
    services.udev.packages = [ pkgs.bazecor ];
  };
}
