_: {
  flake.homeModules.vivaldi =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        home.packages = [ pkgs.vivaldi ];

        # Chromium-based browsers record their current executable's absolute path
        # in PWA launchers. That path becomes stale after moving to or updating Nix.
        home.activation.fixVivaldiPwaLaunchers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          applications_dir=${lib.escapeShellArg "${config.xdg.dataHome}/applications"}

          if [[ -d "$applications_dir" ]]; then
            for desktop_file in "$applications_dir"/*.desktop; do
              [[ -f "$desktop_file" ]] || continue
              if ${pkgs.gnugrep}/bin/grep --quiet --extended-regexp \
                '^Exec=[^[:space:]]*/vivaldi[[:space:]]+.*--app-id=' "$desktop_file"; then
                $DRY_RUN_CMD ${pkgs.gnused}/bin/sed --in-place --regexp-extended \
                  '/^Exec=.*--app-id=/ s|^Exec=[^[:space:]]*/vivaldi[[:space:]]+|Exec=vivaldi |' \
                  "$desktop_file"
              fi
            done
          fi
        '';
      };
    };

  flake.nixosModules.vivaldi = { pkgs, ... }: {
    config.environment.systemPackages = [ pkgs.vivaldi ];
  };
}
