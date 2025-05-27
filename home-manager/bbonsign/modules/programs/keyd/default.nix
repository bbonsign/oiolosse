{ pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      keyd
    ];

  };
}
