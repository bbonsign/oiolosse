_:
{
  flake.homeModules.ssh = {pkgs,...}: {

    config = {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks."*".addKeysToAgent = "yes";
        extraConfig = ''
        Host *
          IdentityAgent ~/.1password/agent.sock
        '';
      };
      services = {
        ssh-agent.enable = true;
      };
    };
  };
}

