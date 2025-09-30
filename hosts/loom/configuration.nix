# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ 
    
    ];



  ## Cosmic Desktop Environment
  services.desktopManager.cosmic.enable = true;
  ## Crucial for lilyinstarlight/nixos-cosmic for faster builds:
  nix.settings = {
    substituters = [ "https://cosmic.cachix.org/" ];
    trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
   };

  # Correct way to set Surface-specific options
  #hardware.surface = { # This is the main attribute set for Surface hardware
  #  enable = true; # Enables the core Surface hardware support (kernel patches etc.)
  #  ipts.enable = true; # Enables touch and pen support
  #};

  # services.surface-control.enable = true; # This remains a separate service
    # Keep your increased swap and zramSwap settings
  swapDevices = [
    { device = "/swapfile"; size = 8192; } # Or 16384 for 16GB
  ];
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    priority = 100;
  };

  # nix.maxJobs = 1; # Only allow one build job at a time

  # Enable NTFS support
  boot.kernelModules = [ "ntfs3" ];

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/4A39-7CF4";
      fsType = "vfat";
    };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Loom"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Anchorage";

  # programs.firefox.enable = true;  


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #  font = "Lat2-Terminus16";
  #  keyMap = "us";
  #  useXkbConfig = true; # use xkb.options in tty.
  #};

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.desktopManager.gnome.enable = false;
  services.displayManager.gdm.enable = true;

  ## Systemd configuration for disabling auto sleep
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  ## Systemd login configuration
  #services.logind = {
  #  lidSwitchExternalPower = "ignore";
  #  lidSwitchBattery = "ignore";
  #};

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # NVIDIA
  # --- NVIDIA Driver Configuration ---
  # Enable the proprietary NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  # Configure the NVIDIA driver details
  hardware.nvidia = {
    # This ensures that the NVIDIA kernel module is built against your
    # currently active kernel (which is linux-surface).
    # NixOS will automatically try to compile the proprietary driver
    # for your current kernel unless you specify a different one.
    # boot.kernelPackages = config.boot.kernelPackages.nvidiaPackages.stable; # DO NOT UNCOMMENT THIS for Surface, as it might override the Surface kernel

    # Enable modesetting for better Wayland support and overall display.
    # Essential for modern NVIDIA setups.
    modesetting.enable = true;

    # Enable NVIDIA power management settings for better power efficiency.
    # This might require some tuning or might not work perfectly on all laptops.
    powerManagement.enable = true;

    # Set to false to use the proprietary (closed-source) driver.
    # Set to true to attempt to use the open-source NVIDIA kernel modules (new, might not work on GTX 1050 yet).
    # For stability and performance with GTX 1050, keep false.
    open = false;

    # Enable the NVIDIA settings utility for fine-tuning your GPU.
    nvidiaSettings = true;
  };

  # Allow unfree packages for NVIDIA drivers (if not already done in flake.nix)
  # If you already have `pkgs = import nixpkgs { config = { allowUnfree = true; }; };` in your flake.nix,
  # you might not strictly need this here, but it acts as a safeguard.
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "cuda" # If you plan to use CUDA
      # Add other unfree NVIDIA related packages if encountered
    ];

  #### Jellyfin server

  # Enable the Jellyfin service
  services.jellyfin = {
    enable = true;
    openFirewall = true;

    # Specify the user and group Jellyfin will run as.
    user = "tarobutter";
    group = "users";

    # dataDir = "/var/lib/jellyfin"; # Default is fine, uncomment if you want to change it
  };

  # Make sure the 'jellyfin' user is part of the 'video' group
  # This grants it necessary permissions to access GPU devices.
  users.groups.video.members = [ "jellyfin" ];



  ##### Suwayomi server
  ###  
  services.suwayomi-server = {
    enable = true;

    dataDir = "/var/lib/suwayomi/"; # Default is "/var/lib/suwayomi-server"
    openFirewall = true;

    settings = {
      server.port = 4567;
      server.enableSystemTray = true;
      server.autoDownloadNewChapters = true;
      server.downloadsPath = "/home/tarobutter/Media/Manga_1/";
      server.backupPath = "/home/tarobutter/Media/Manga_2/";
      server.debugLogsEnable = true;
    };
  };




  # Enable CUPS to print documents.
  services.printing.enable = true;


  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tarobutter = {
    isNormalUser = true;
    extraGroups = [ "wheel" "jellyfin" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    jellyfin
    jellyfin-ffmpeg
    coreutils
  ];

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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

