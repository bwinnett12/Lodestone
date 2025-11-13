
# https://search.nixos.org/options: NixOS manual (`nixos-help`)

{ config, lib, pkgs, inputs, nixosCosmicModule, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      nixosCosmicModule
      
    ];


  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ####### System Information

  networking.hostName = "Loom";
  time.timeZone = "America/Anchorage";
  i18n.defaultLocale = "en_US.UTF-8";




  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ## Build modifiers
  # nix.maxJobs = 1; # Only allow one build job at a time




  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ####### Boot settings

  # Enable NTFS support
  boot.kernelModules = [ "ntfs3" "ext4" "btrfs" "vfat" "exfat" ];
  

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;



  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ######## Network settings

  services.openssh.enable = true;

  ### Networking mechanism
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;  ## To disable the firewall altogether.




  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ###### The environment

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  #### Desktop Environments
  # Enable the GNOME Desktop Environment.
  services.xserver.desktopManager.gnome.enable = false;
  services.displayManager.gdm.enable = true;


  # Enable the Cosmic Desktop Environment
  # services.desktopManager.cosmic.enable = true;
  # services.displayManager.cosmic.enable = false;  # Use the Gnome display Manager instead. 
  

  ## Crucial for lilyinstarlight/nixos-cosmic for faster builds:
  #nix.settings = {
  #  substituters = [ "https://cosmic.cachix.org/" ];
  #  trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
  # };


  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;




  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ## Sound
  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
  };




  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  #### Nvidia settings

  ## Enable the NVIDIA driver for Xorg and load the kernel module
  # Enable the proprietary NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable graphic card
  hardware.graphics.enable = true;

  # Configure the NVIDIA module
  hardware.nvidia = {

    # This ensures that the NVIDIA kernel module is built against your
    # currently active kernel (which is linux-surface).
    # NixOS will automatically try to compile the proprietary driver
    # for your current kernel unless you specify a different one.
    # boot.kernelPackages = config.boot.kernelPackages.nvidiaPackages.stable; # DO NOT UNCOMMENT THIS for Surface, as it might override the Surface kernel


    # Use the stable driver package
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Enable modesetting for better Wayland support and overall display.
    # Essential for modern NVIDIA setups.
    modesetting.enable = true;

    # Set to false to use the proprietary (closed-source) driver.
    # Set to true to attempt to use the open-source NVIDIA kernel modules (new, might not work on GTX 1050 yet).
    # For stability and performance with GTX 1050, keep false.
    open = false;

    # Enable the NVIDIA settings application
    nvidiaSettings = true;

    # Enable NVIDIA power management settings for better power efficiency.
    # This might require some tuning or might not work perfectly on all laptops.
    powerManagement.enable = true;
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








  ## Systemd configuration for disabling auto sleep
  #systemd.targets = {
  #  sleep.enable = false;
  #  suspend.enable = false;
  #  hibernate.enable = false;
  #  hybrid-sleep.enable = false;
  #};

  ## Systemd login configuration
  #services.logind = {
  #  lidSwitchExternalPower = "ignore";
  #  lidSwitchBattery = "ignore";
  #};



  




  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##



  ## Docker
  virtualisation.docker.enable = true;


  ####### Key mapping
  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # console = {
  #  font = "Lat2-Terminus16";
  #  keyMap = "us";
  #  useXkbConfig = true; # use xkb.options in tty.
  #};




  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##







  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ## User groups

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tarobutter = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };



  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ## Programs
  
  programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    vlc
    coreutils
    exfatprogs
    parted
  ];


  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ## Unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "cuda"
      # Other Nvidia packages
    ];


  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ##                                                                         ##
  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##

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

