_: {
  flake.nixosModules.nextcloud-calendar =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      backendPort = 8080;
      tailscale = lib.getExe config.services.tailscale.package;
    in
    {
      config = {
        services.nextcloud = {
          enable = true;
          package = pkgs.nextcloud34;
          hostName = "localhost";
          https = true;

          database.createLocally = true;
          configureRedis = true;

          config = {
            dbtype = "pgsql";
            adminuser = "admin";
            adminpassFile = "/var/lib/nextcloud-secrets/admin-password";
          };

          settings = {
            # The tailnet DNS suffix is runtime state, so trust only this node's
            # MagicDNS name without embedding the private suffix in the repository.
            trusted_domains = [ "mithlond.*.ts.net" ];
            trusted_proxies = [ "127.0.0.1" ];
            overwriteprotocol = "https";
          };

          appstoreEnable = false;
          extraApps = {
            inherit (config.services.nextcloud.package.packages.apps) calendar;
          };
        };

        # TLS terminates in tailscaled; nginx is unreachable from the LAN and WAN.
        services.nginx.virtualHosts.${config.services.nextcloud.hostName}.listen = [
          {
            addr = "127.0.0.1";
            port = backendPort;
          }
        ];

        systemd.tmpfiles.rules = [
          "d /var/lib/nextcloud-secrets 0700 root root - -"
        ];

        systemd.services.tailscale-serve-nextcloud = {
          description = "Tailnet-only HTTPS proxy for Nextcloud Calendar";
          after = [
            "tailscaled.service"
            "nginx.service"
          ];
          requires = [
            "tailscaled.service"
            "nginx.service"
          ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${tailscale} serve --bg --yes --https=443 http://127.0.0.1:${toString backendPort}";
            ExecStop = "${tailscale} serve --https=443 off";
          };
        };
      };
    };
}
