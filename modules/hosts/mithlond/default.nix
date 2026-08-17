{
  inputs,
  pkgs,
  self,
  ...
}:
{
  flake.nixosConfigurations = {
    mithlond = inputs.nixpkgs.lib.nixosSystem {
      # inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./_hardware-configuration.nix

        self.nixosModules.boot
        self.nixosModules.home-manager
        self.nixosModules.locale
        self.nixosModules.networking
        # self.nixosModules.nextcloud-calendar
        self.nixosModules.nix
        self.nixosModules.tailscale
        self.nixosModules.users

        (
          { config, lib, ... }:
          let
            mealieServiceName = "svc:mealie";
            tailscale = lib.getExe config.services.tailscale.package;
          in
          {
            home-manager.users.bbonsign = self.homeModules.bbonsignServerHomeModule;

            # Blank the console display while keeping the laptop running with its lid closed.
            boot.kernelParams = [ "consoleblank=60" ];
            services.logind.settings.Login = {
              HandleLidSwitch = "ignore";
              HandleLidSwitchDocked = "ignore";
              HandleLidSwitchExternalPower = "ignore";
            };
            systemd.targets = {
              sleep.enable = false;
              suspend.enable = false;
              hibernate.enable = false;
              hybrid-sleep.enable = false;
            };

            # SSH and web applications are reachable only over Tailscale.
            services.openssh = {
              enable = true;
              openFirewall = false;
              settings.PermitRootLogin = "no";
            };
            # Permit remote deployment of closures built on Telperion.
            nix.settings.trusted-users = [ "bbonsign" ];
            services.mealie = {
              enable = true;
              listenAddress = "127.0.0.1";
              port = 9000;
              settings.BASE_URL = "https://mealie.duckbull-wahoo.ts.net";
            };
            networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];

            systemd.services.tailscale-serve-mealie = {
              description = "Tailnet-only HTTPS proxy for Mealie";
              after = [
                "tailscaled.service"
                "mealie.service"
              ];
              requires = [
                "tailscaled.service"
                "mealie.service"
              ];
              wantedBy = [ "multi-user.target" ];

              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                ExecStart = "${tailscale} serve --service=${mealieServiceName} --yes --https=443 http://127.0.0.1:9000";
                ExecStop = "${tailscale} serve drain ${mealieServiceName}";
              };
            };
          }
        )

        # When `home-manager.useGlobalPkgs = true`, HM cannot set
        # `nixpkgs.{overlays,config}` itself, so configure them here at
        # the NixOS level instead.
        {
          nixpkgs.overlays = [
            inputs.neovim-nightly-overlay.overlays.default
          ];
          nixpkgs.config = {
            allowUnfree = true;
            allowUnfreePredicate = _pkg: true;
          };
        }

        {
          # This value determines the NixOS release from which the default
          # settings for stateful data, like file locations and database versions
          # on your system were taken. It‘s perfectly fine and recommended to leave
          # this value at the release version of the first install of this system.
          # Before changing this value read the documentation for this option
          # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
          system.stateVersion = "26.05"; # Did you read the comment?
        }
      ];
    };
  };

}
