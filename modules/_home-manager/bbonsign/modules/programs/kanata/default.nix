{ pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      kanata
    ];

    #   systemd.user = {
    #     services = {
    #     kanata = {
    #     enable = true;
    #     keyboards = {
    #       default = {
    #         extraDefCfg = ''
    #           process-unmapped-keys  yes
    #           log-layer-changes      no
    #           linux-dev              /dev/input/by-id/usb-Apple_Inc._Apple_Internal_Keyboard___Trackpad_D3H835500E1F-if01-event-kbd
    #         '';
    #         config = builtins.readFile ./kanata.kbd;
    #       };
    #     };
    #   };
    # };
  };
}

# systemd.user = {
#   services = {
#     kanata = {
#       Install.WantedBy = [ "niri.service" ];
#       Unit = {
#         After = [ "niri.service" ];
#         PartOf = [ "graphical-session.target" ];
#         Requisite = [ "graphical-session.target" ];
#       };
#       Service = {
#         Type = "simple";
#         Restart = lib.mkForce "on-failure";
#         ExecStart = "${pkgs.swayidle}/bin/swayidle";
#       };
#     };
