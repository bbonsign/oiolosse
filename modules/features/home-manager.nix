
{inputs, self, ...}:
{
  flake.homeModules.home-manager = {pkgs,...}: {
    config = {
      # This value determines the home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update home Manager without changing this value. See
      # the home Manager release notes for a list of state version
      # changes in each release.
      home.stateVersion = "22.11";

      # Let home Manager install and manage itself.
      programs.home-manager.enable = true;
    };
  };

  flake.nixosModules.home-manager = {pkgs,...}: {
    imports = [
      # make home-manager as a module of nixos
      # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
      inputs.home-manager.nixosModules.home-manager

      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hmbak";
        home-manager.users.bbonsign = self.homeModules.bbonsignHomeModule;
      }

      # Since Home Manager is installed via its NixOS module and 'home-manager.useUserPackages' is
      # enabled, you need to add the following to your NixOS configuration so that the portal
      # definitions and DE provided configurations get linked.
      {
        environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];
      }
    ];
  };
}
