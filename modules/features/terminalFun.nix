_: 
{
  flake.homeModules.terminalFun = {pkgs, ...}: {

    config = {
      home.packages = [
        pkgs.cbonsai
        pkgs.cmatrix
        pkgs.cowsay
      ];

    };
  };
}
