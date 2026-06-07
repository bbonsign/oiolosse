{inputs, ...}:
{
  flake.homeModules.noctalia = _:
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      config = {
        programs.noctalia = {
          enable = true;
          # systemd.enable = true;
        };
      };
    };
}
