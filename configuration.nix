# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
    #baseconfig = { allowUnfree = true; };
    #unstable = import <unstable> { config = baseconfig; };
    passwords = import ./passwords.nix;
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./nvidia.nix
      ./sway.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  #boot.kernelModules = [ "kvm-amd" ];
  #
  
  fonts.fonts = with pkgs; [
    source-code-pro
  ];
  

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

  #boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_4_19.override {
  #  argsOverride = rec {
  #    src = pkgs.fetchurl {
  #          url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
  #          sha256 = "0h02pxzzwc5w2kfqw686bpxc13a93yq449lyzxxkxq1qilcsqjv5";
  #    };
  #    version = "4.19.107";
  #    modDirVersion = "4.19.107";
  #    };
  #});

  #nixpkgs.config = {
  #  packageOverrides = super: let self = super.pkgs; in
  #  {
  #    linuxPackages_latest = super.linuxPackages_latest.extend (self: super: {
  #      nvidiaPackages = super.nvidiaPackages // {
  #        stable = unstable.linuxPackages_latest.nvidiaPackages.stable;
  #      };
  #    });
  #  };
  #};
  #boot.kernelPackages = unstable.linuxPackages_latest;
  nixpkgs.config.allowUnfree = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  #networking.interfaces.enp30s0.useDHCP = true;
  networking.interfaces.enp33s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    mkpasswd
    pciutils
    git
  ];
  programs.adb.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  #services.xserver.enable = true;
  #services.xserver.layout = "us";
  #services.xserver.videoDrivers = [ "nvidia" ];
  #services.xserver.exportConfiguration = true;
  #services.xserver.config = pkgs.lib.mkOverride 50 (builtins.readFile ./xorg.conf);
  # Enable the KDE Desktop Environment.
  #services.xserver.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;

  programs.sway.enable = true;
  
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.root.hashedPassword = passwords.root;
  users.users.vkhougaz = {
    shell = pkgs.zsh;
    isNormalUser = true;
    hashedPassword = passwords.vkhougaz;
    extraGroups = [
      "vkhougaz"
      "wheel"
      "docker"
      "dialout"
      "adbusers"
      "libvirtd"
     ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

