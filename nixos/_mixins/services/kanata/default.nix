_:

{
  config = {
    services.kanata = {
      enable = true;
      keyboards = {
        default = {
          extraDefCfg = ''
            process-unmapped-keys  yes
            log-layer-changes      no
            linux-dev              /dev/input/by-id/usb-Apple_Inc._Apple_Internal_Keyboard___Trackpad_D3H835500E1F-if01-event-kbd
          '';
          config = builtins.readFile ./kanata.kbd;
        };
      };
    };
  };
}
