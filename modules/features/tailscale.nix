_:
{
  flake.nixosModules.tailscale = _:
    {
      config = {
        services.tailscale.enable = true;
      };
    };
}

