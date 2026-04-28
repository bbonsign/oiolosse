_:
{
  flake.homeModules.users = {pkgs,...}:
    {
      config = {
      };
    };

  flake.nixosModules.users = {pkgs,...}:
    {
      config = {
        # Define a user account. Don't forget to set a password with ‘passwd’.
        users.users.bbonsign = {
          isNormalUser = true;
          description = "Brian Bonsignore";
          extraGroups = [ "networkmanager" "wheel" ];
          # packages = with pkgs; [   ];
        };
        # users.defaultUserShell = pkgs.fish;
      };
    };
}
