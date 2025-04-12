{ config, pkgs, ... }:

{
  # imports = [ ./mithlond/configuration.nix ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes pipe-operators
      download-buffer-size = 524288000 # 500MiB (default: 64 MiB)
    '';
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.tailscale.enable = true;

  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.enable = true;
  services.displayManager.enable = false;

  services.xserver = {
    # enable = true;
    # autorun = false;

    xkb = {
      layout = "us";
      variant = "";
      options = "ctrl:no_caps";
    };
  };

  security.rtkit.enable = true;
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
    ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    brightnessctl
    distrobox
    firefox
    git
    inotify-tools
    ncurses
    neovim
    pciutils
    python312
    sqlite
    vivaldi
    wget
  ];

  # https://nix-community.github.io/home-manager/options.html#opt-programs.zsh.enableCompletion
  environment.pathsToLink = [ "/share/zsh" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.fish.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "bbonsign" ];
  };

  # Enable networking
  networking.networkmanager.enable = true;

}
