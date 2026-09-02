{ inputs, pkgs, self, ... }:
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
        self.nixosModules.nextcloud-calendar
        self.nixosModules.nix
        self.nixosModules.tailscale
        self.nixosModules.users

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

          # SSH and Mealie are reachable only over Tailscale.
          services.openssh = {
            enable = true;
            openFirewall = false;
            settings.PermitRootLogin = "no";
          };
          services.mealie = {
            enable = true;
            listenAddress = "0.0.0.0";
            port = 9000;
          };
          networking.firewall.interfaces.tailscale0.allowedTCPPorts = [
            22
            9000
          ];
        }

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
          system.stateVersion = "23.05"; # Did you read the comment?
        }
      ];
    };
  };

}
