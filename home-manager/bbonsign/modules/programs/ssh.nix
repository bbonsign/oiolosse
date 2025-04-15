_:
{
  config = {
    programs.ssh = {
      enable = true;
      addKeysToAgent = "yes";
      extraConfig = ''
        Host *
          IdentityAgent ~/.1password/agent.sock
      '';
    };
  };
}
