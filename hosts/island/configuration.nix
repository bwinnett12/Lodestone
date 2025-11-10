# https://search.nixos.org/options: NixOS manual (`nixos-help`)

{ config, lib, pkgs, inputs, nixosCosmicModule, ... }:

{
  ### Import Mechanism
  imports =
    [ 
      nixosCosmicModule
    ];

  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ### System Information

  networking.hostName = "Island";
  time.timeZone = "America/Anchorage";
  i18n.defaultLocale = "en_US.UTF-8";

  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ### Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ]; 

    ## Settings for cosmic
    # substituters = [ "https://cosmic.cachix.org/" ];
    # trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
  };

  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ### General settings
  virtualisation.docker.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  ## Key mapping
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
  ## Build modifiers
  # nix.maxJobs = 1; # Only allow one build job at a time





  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ####### Boot settings

  # Enable NTFS support
  boot.kernelModules = [ "ntfs3" "ext4" "btrfs" "vfat" "exfat" ];
  

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";



  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ######## Network settings
  
  services.openssh.enable = true;

  ### Networking mechanism
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.


  ### Caddy for HTTPS Proxy
#  services.caddy = {
#    enable = true;
#    email = "bwinnett12@gmail.com";  # Required for Let's Encrypt registration
#    virtualHosts."komga.platatoo.com" = { # Replace with your public domain
#      extraConfig = ''
#        # Caddy automatically generates a self-signed certificate for localhost
#        reverse_proxy 127.0.0.1:8081
#      '';
#     # Automatically opens ports 80/443 in the firewall.
#      # If you want to use a specific port, you must configure Caddy's listen addresses.
#    };
#  };



  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports in the firewall.
  
  
  
  
  networking.firewall.allowedTCPPorts = [ 
    # 80  ## 80 - Caddy
    # 443  ## 443 - Caddy
    # 8443  ## 8443 - Caddy
    8080  ## 8080 - LocalAI
    8081  ## 8081 - LocalAI
    2104  ## 2104 - Komga
    2108  ## 2108 - Suwayomi Server
    4822  ## 4822 - Guacamole

  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;  ## To disable the firewall altogether.



  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ###### The environment

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  #### Desktop Environments
  # Enable the GNOME Desktop Environment.
  services.desktopManager.gnome.enable = true; 
  services.displayManager.gdm.enable = true;

  # Enable the Cosmic Desktop Environment
  # services.desktopManager.cosmic.enable = true;
  # services.displayManager.cosmic.enable = false;  # Use the Gnome display Manager instead. 





  #### Sleep schedule
  ## Systemd configuration for disabling auto sleep
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };



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

  # Enable graphic card
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  ## Enable the NVIDIA driver for Xorg and load the kernel module
  services.xserver.videoDrivers = [ "nvidia" ];

  virtualisation.docker.rootless.daemon.settings.features.cdi = true;
  #virtualisation.docker.enableNvidia = true;
  hardware.nvidia-container-toolkit.enable = true;  

  # Configure the NVIDIA module
  hardware.nvidia = {

    # Use the stable driver package
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Enable modesetting for better Wayland support and overall display.
    # Essential for modern NVIDIA setups.
    modesetting.enable = true;

    # Open-source drivers are for RTX 20-series and newer
    # Set to false to use the proprietary (closed-source) driver.
    open = false;

    # Enable the NVIDIA settings application
    nvidiaSettings = true;

    # Power management set to false. 
    powerManagement.enable = false;
  };













  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  #### Guacamole
  ### Guacamole
  services.guacamole-server = {
    enable = true;
    host = "127.0.0.1";
    userMappingXml = ./guacamole/user-mapping.xml;
    # package = pkgs.unstable.guacamole-server; # Optional, use only when you want to use the unstable channel
  };

  services.guacamole-client = {
    enable = true;
    enableWebserver = true;

    settings = {
      guacd-port = 4822;
      guacd-hostname = "127.0.0.1";
    };
  };























#  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
#  ## Local AI by docker-compose
#
#
#
#  systemd.services.localai-docker-compose = {
#
#    ### LocalAI
#    description = "LocalAI via Docker Compose";
#
#
#    # Wait for network and your storage mount to be ready
#    # after = [ "network.target" "docker.service" "storage-Orchid.mount" ];
#    
#    requires = [ "docker.service" ];
#    wantedBy = [ "multi-user.target" ];
#
#
#    serviceConfig = {
#      # Replace the path with wherever you put your docker-compose.yml
#      ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f /etc/localai/docker-compose.yml up"; 
#      ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f /etc/localai/docker-compose.yml down";
#
#      ## Currently using root
#      ## #todo - Switch to localai or shortstack user
#      ## Currently root
#      User = "root";
#      # Set the working directory to the directory of the compose file
#      WorkingDirectory = "/etc/localai"; 
#      Restart = "on-failure";
#      RestartSec = "5s";
#  };
#};















  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ##### Suwayomi server
  ###  
  services.suwayomi-server = {
    enable = true;
    user = "suwayomi";
    group = "suwayomi";

    dataDir = "/storage/Orchid/shortstack/suwayomi-server"; 
    #openFirewall = true;

    settings = {
      server.port = 2108;
      server.address = "0.0.0.0";
      server.enableSystemTray = true;
      server.autoDownloadNewChapters = true;
      server.downloadsPath = "/storage/Orchid/Manga";
      server.backupPath = "/var/lib/suwayomi/backups";
      server.debugLogsEnable = true;
    };
  };















  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ## Komga
  services.komga.enable = true;

  services.komga = {
    openFirewall = false;

    # Configuration for the internal Komga Spring Boot application
    settings = {
      server.port = 2104;
      address = "0.0.0.0";
    };
  };

  # users.groups.komga = "users";










  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ## User groups

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tarobutter = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "storage-yarrow" "storage-orchid"];
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

    openssl
    nettools
    rustscan

    coreutils

    exfatprogs
    parted
    btrfs-progs
    lsof

    guacamole-client

    docker-compose

    nvidia-container-toolkit
  ];


  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ## Unfree packages
  nixpkgs.config.allowUnfree = true;



  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  ### Beyond here lies nothin'
  ### Nothin' we can call our own

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
