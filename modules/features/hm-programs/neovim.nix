{inputs, ...}:
{
  flake.homeModules.neovim = {pkgs, ...}:
    {
      config = {
        programs.neovim = {
          sideloadInitLua = true;
          enable = true;
          defaultEditor = true;
          viAlias = true;
          vimAlias = true;
          withNodeJs = true;
          withPython3 = true;
          withRuby = false;
          extraPackages = [
            pkgs.gcc
            pkgs.lua-language-server
          ];
        };
      };
    };

  flake.nixosModules.neovim = {pkgs, ...}: {
    config = {
      nixpkgs.overlays = [
        inputs.neovim-nightly-overlay.overlays.default
      ];
    };
  };
}
