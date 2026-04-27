_:
{
  flake.homeModules.keyd = {pkgs, ...}:
    {
      config = {
        home.packages = with pkgs; [
          keyd
        ];
      };
    };
}
