# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: let
  stable = with pkgs.stable-22_05; [
  ];

  unstable = with pkgs; [
    _1password-gui-beta
    alejandra
    awscli2
    bat
    bind
    chezmoi
    chromium
    chromium
    clusterctl
    docker
    docker-compose
    firefox
    fish
    fluxcd
    git
    gnome.gnome-tweaks
    gnumake
    go
    gopls
    htop
    jq
    k9s
    kubectl
    kustomize
    libinput-gestures
    neovim
    nix-index
    nodePackages.yarn
    nodejs
    ripgrep
    slack
    ssm-session-manager-plugin
    tdesktop
    terraform
    tig
    vim
    wget
    wmctrl
    xclip
    zathura
    zoom-us
  ];
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  virtualisation.docker.enable = true;

  networking.hostName = "xps15"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.utf8";
    LC_IDENTIFICATION = "es_ES.utf8";
    LC_MEASUREMENT = "es_ES.utf8";
    LC_MONETARY = "es_ES.utf8";
    LC_NAME = "es_ES.utf8";
    LC_NUMERIC = "es_ES.utf8";
    LC_PAPER = "es_ES.utf8";
    LC_TELEPHONE = "es_ES.utf8";
    LC_TIME = "es_ES.utf8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "altgr-intl";
  };

  fonts = {
    fonts = with pkgs; [(nerdfonts.override {fonts = ["JetBrainsMono"];})];
    fontDir.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions =
      lib.optionalString (config.nix.package == pkgs.nixVersions.stable)
      "experimental-features = nix-command flakes";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.enric = {
    isNormalUser = true;
    description = "enric";
    extraGroups = ["networkmanager" "wheel" "input" "docker"];
    shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.shells = [pkgs.bash pkgs.fish];
  environment.systemPackages = stable ++ unstable;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
