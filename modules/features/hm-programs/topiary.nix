_:
{
  flake.homeModules.topiary = {pkgs, ...}:
    {
      config = {
        home.packages = with pkgs; [
          topiary
        ];
      };
    };
}
