_:
{
  flake.nixosModules.tailscale = _:
    {
      config = {
        services.tailscale.enable = true;
        # Permit direct peer connections; app ports remain restricted by the host firewall.
        services.tailscale.openFirewall = true;
      };
    };
}
