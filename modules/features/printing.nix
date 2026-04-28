_:
{

  flake.nixosModules.printing = _:
    {
      config = {
        # Enable CUPS to print documents.
        services.printing.enable = true;
        services.printing.drivers = [
          # Driver for Epson WF-2950 printer
          # pkgs.epson-escpr
        ];
      };
    };
}

