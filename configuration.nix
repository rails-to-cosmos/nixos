# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, stdenv, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.supportedFilesystems = [ "ntfs" ];

  # fileSystems."/home/akatovda/windows" = {
  #   device = "/dev/nvme0n1p3";
  #   fsType = "ntfs";
  #   options = [ "rw" "uid=1000"];
  # };

  boot.loader = {
    # systemd-boot.enable = true;

    efi = {
      # canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };

    grub = {

      enable                = true;
      copyKernels           = true;
      efiInstallAsRemovable = true;
      efiSupport            = true;
      fsIdentifier          = "label";
      # splashImage           = ./backgrounds/grub-nixos-3.png;
      # splashMode            = "stretch";
      devices               = [ "nodev" ];

      # enable = true;
      useOSProber = true;
      # version = 2;
      # devices = [ "nodev" ];  # "/dev/nvme0n1p1";
      # device = "nodev";
      # device = "/dev/nvme0n1p1";
      # extraEntries = ''
      #   menuentry "Windows" {
      #     insmod part_gpt
      #     insmod fat
      #     insmod search_fs_uuid
      #     insmod chain
      #     search --fs-uuid --set=root $FS_UUID
      #     chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      #   }
      # '';
    };
  };

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  services = {
    dbus = {
      packages = [ pkgs.gnome3.dconf ];
    };

    udev = {
      packages = [ pkgs.gnome3.gnome-settings-daemon ];
    };

    xserver = {
	    enable = true;
	    dpi = 96;
	    layout = "us";
	    xkbOptions = "lv3:ralt_alt,terminate:ctrl_alt_bksp,ctrl:swapcaps";
	    xkbVariant = "mac";
      libinput = {
		    enable = true;
		    tapping = true;
		    clickMethod = "clickfinger";
		    naturalScrolling = true;
 	    };

      displayManager.gdm.enable = true;
      desktopManager.gnome3.enable = true;

      # desktopManager = {
      #   gnome3.enable = true;
      #   gnomeExtensions.material-shell.enable = true;
      #   gnomeExtensions.appindicator.enable = true;
      # };

	    # displayManager.sddm.enable = true;
	    # desktopManager.plasma5.enable = true;

      # desktopManager = {
      #   xterm.enable = false;
      # };

      # displayManager = {
      #   defaultSession = "none+i3";
      # };

	    # windowManager.i3 = {
      #   enable = true;
      #   extraPackages = with pkgs; [
      #     i3status
      #     i3lock
      #     i3blocks
      #   ];
      # };

      # wacom = {
      #   enable = true;
      # };

    };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;

  services.blueman.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   wget vim
  #   firefox
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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
  system.stateVersion = "20.09"; # Did you read the comment?

  users.users.akatovda = {
	  isNormalUser = true;
	  home = "/home/akatovda";
	  description = "Dmitry Akatov";
	  extraGroups = [ "wheel" "networkmanager" "disk" "audio" "video" "systemd-journal" ];
	  createHome = true;
	  uid = 1000;
	  shell = "/run/current-system/sw/bin/bash";
  };

  networking.networkmanager.enable = true;

  nixpkgs.config = {
    packageOverrides = pkgs: rec {
      polybar = pkgs.polybar.override {
        i3Support = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    bmon
    coreutils
    dnsutils
    iproute
    wirelesstools
    termite
    gnumake
    emacs
    git
    htop
    unzip
    zip
    scala
    sbt
    ammonite-repl
    jre8
	  python3
    python3.pkgs.pip
    python3.pkgs.setuptools
    python3.pkgs.virtualenv
    jupyter
	  libnotify
	  libreoffice-fresh
	  thunderbird
	  vlc
	  wget youtube-dl
  	chromium
    compton
    dmenu
    dunst
    transmission
    gparted
    firefox
    gotop
    libnotify
    pango
    ranger
    redshift
    rofi
    sxhkd
    tdesktop
    xournalpp
    xclip
    next
  ];

  console.useXkbConfig = true;

  services.emacs.defaultEditor = true;
  services.emacs.enable = true;

  fonts = {
	  fontconfig.enable = true;
	  fontconfig.hinting.autohint = true;
	  fontconfig.antialias = true;
	  enableFontDir = true;
	  enableGhostscriptFonts = true;
	  fonts = with pkgs; [
		  fira
		  fira-code
		  fira-mono
		  font-awesome_5
		  ibm-plex
		  nerdfonts
		  opensans-ttf
		  overpass
		  roboto
		  source-code-pro
		  terminus_font_ttf
		  ubuntu_font_family
      fantasque-sans-mono
      fira-code-symbols
      material-icons
      material-design-icons
      (nerdfonts.override {
        fonts = [ "JetBrainsMono" ];
      })
	  ];
	};

  services.syncthing = {
    enable = true;
    user = "akatovda";
    dataDir = "/home/akatovda/sync";
    configDir = "/home/akatovda/sync/.config/syncthing";
 };

}
