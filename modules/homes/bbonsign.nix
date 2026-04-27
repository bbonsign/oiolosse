{
inputs,
self,
...
}: {
  flake.homeConfigurations.bbonsign = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";

    # Specify your home configuration modules here, for example, the path to your home.nix.
    modules = [
      self.homeModules.bbonsignHomeModule
    ];

    # Optionally use extraSpecialArgs to pass through arguments to home.nix
    # extraSpecialArgs = { inherit inputs system; };
    extraSpecialArgs = { inherit inputs; isNixOS = false; };
  };

  flake.homeModules.bbonsignHomeModule = {pkgs, ...}: {
    imports = [
      ../_home-manager/bbonsign/home.nix
      self.homeModules.beam
      self.homeModules.bluetooth
      self.homeModules.cursor
      self.homeModules.font
      self.homeModules.home-manager
      self.homeModules.misc-packages
      self.homeModules.niri
      self.homeModules.nix
      self.homeModules.shell-prompt
      self.homeModules.shells
      self.homeModules.ssh
      self.homeModules.terminalFun
      self.homeModules.vcs
      self.homeModules.xdg
    ];

    config = {
      home.username = "bbonsign";
      home.homeDirectory = "/home/bbonsign";

      home.packages = [
        self.packages.x86_64-linux.lf
      ];

    };
  };
}
