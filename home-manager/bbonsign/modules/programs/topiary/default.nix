{ pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      topiary
    ];

  };
}
