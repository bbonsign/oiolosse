_:
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
          extraPackages = with pkgs; [ gcc lua-language-server ];
        };
      };
    };
}
