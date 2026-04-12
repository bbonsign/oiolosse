_:
{
  flake.homeModules.bluetooth = {...}: {

    config = {
      services = {
        # https://nixos.wiki/wiki/Bluetooth#Using_Bluetooth_headset_buttons_to_control_media_player
        mpris-proxy.enable = true;
      };
    };
  };

  flake.nixosModules.bluetooth = {pkgs, ...}: {
    hardware = {
      bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
    };
    services.blueman.enable = true;
    environment.systemPackages = [
      pkgs.bluez
    ];
  };
}

