{ inputs, ... }:
{
  flake.homeModules.umbriel = { pkgs, ... }: {
    imports = [
      inputs.umbriel.homeModules.default
    ];

    config = {
      programs.umbriel = {
        enable = true;
        package = inputs.umbriel.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };

      # Make the compositor session and its screen-sharing portal available on
      # the Fedora host where this standalone Home Manager profile is used.
      systemd.user.packages = [
        inputs.umbriel.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
      xdg.portal = {
        extraPortals = [ pkgs.xdg-desktop-portal-umbriel ];
        config.umbriel = {
          default = [
            "umbriel"
            "gtk"
          ];
          "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
        };
      };
    };
  };
}
