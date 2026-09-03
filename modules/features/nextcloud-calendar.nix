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
      passwordFile = "/var/lib/nextcloud-secrets/admin-password";
      serviceName = "svc:nextcloud";
      tailscale = lib.getExe config.services.tailscale.package;
    in
    {
      config = {
        services.nextcloud = {
          enable = true;
          package = pkgs.nextcloud34;
          hostName = "nextcloud.duckbill-wahoo.ts.net";
          https = true;

          database.createLocally = true;
          configureRedis = true;

          config = {
            dbtype = "pgsql";
            adminuser = "admin";
            adminpassFile = passwordFile;
          };

          settings = {
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

        systemd.services.nextcloud-admin-password = {
          description = "Provision the initial Nextcloud administrator password";
          before = [ "nextcloud-setup.service" ];
          requiredBy = [ "nextcloud-setup.service" ];

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };

          script = ''
            if [[ ! -s ${passwordFile} ]]; then
              umask 0077
              ${lib.getExe pkgs.openssl} rand -base64 36 > ${passwordFile}.tmp
              ${lib.getExe' pkgs.coreutils "mv"} ${passwordFile}.tmp ${passwordFile}
            fi
          '';
        };

        systemd.services.tailscale-serve-nextcloud = {
          description = "Tailnet-only HTTPS proxy for Nextcloud Calendar";
          after = [
            "tailscaled.service"
            "nginx.service"
            "nextcloud-setup.service"
          ];
          requires = [
            "tailscaled.service"
            "nginx.service"
            "nextcloud-setup.service"
          ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${tailscale} serve --service=${serviceName} --yes --https=443 http://127.0.0.1:${toString backendPort}";
            ExecStop = "${tailscale} serve drain ${serviceName}";
          };
        };
      };
    };
}
