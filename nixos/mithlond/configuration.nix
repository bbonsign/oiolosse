{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./common.nix
    ./desktops
    ./services
  ];

  # Set your time zone.
  time.timeZone = "America/New_York";

  networking.hostName = "mithlond"; # Define your hostname.
  networking.networkmanager.wifi.powersave = false;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  virtualisation = {
    podman = {
      enable = true;
      extraPackages = [ pkgs.podman-compose ];
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  security.rtkit.enable = true;

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  services.tailscale.enable = true;

  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.enable = true;
  services.displayManager.enable = false;

  services.blueman.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "ctrl:no_caps";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [
    # Driver for Epson WF-2950 printer
    # pkgs.epson-escpr
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bbonsign = {
    isNormalUser = true;
    description = "Brian Bonsignore";
    extraGroups = [ "networkmanager" "wheel" ];
    # packages = with pkgs; [   ];
  };
  # users.defaultUserShell = pkgs.fish;

  fonts.packages = with pkgs;
    [
      pkgs.nerd-fonts.fira-code
      pkgs.nerd-fonts.fantasque-sans-mono
    ];

  # https://nix-community.github.io/home-manager/options.html#opt-programs.zsh.enableCompletion
  environment.pathsToLink = [ "/share/zsh" ];


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
