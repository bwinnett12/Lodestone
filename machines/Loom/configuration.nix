
# https://search.nixos.org/options: NixOS manual (`nixos-help`)

{ config, lib, pkgs, inputs, nixosCosmicModule, ... }:

{

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];



  ## Settings for cosmic
  # substituters = [ "https://cosmic.cachix.org/" ];
  # trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];


  services = {
    openssh = { enable = true; };
    tailscale = {
      enable = true; 
      permitCertUid = "caddy";
      #wantedBy = [ "multi-user.target" ];
    };
  };



  networking = {

    hostName = "Loom";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true; # Change this interface name if Loom's physical port is different!

    firewall = {
      enable = true;
      checkReversePath = "loose";
      trustedInterfaces = [ 
        #"tailscale0" 
        ];

      allowedTCPPorts = [ 
        #8080  ## 8080 - LocalAI
        #8081  ## 8081 - LocalAI      
        #8090  ## 8080 - LocalAI


        #4822  ## 4822 - Guacamole
        #3389  ## 3389 - Guacamole

        #2104  ## 2104 - Komga

        9000  ## 9000 - Prometheus
        3000  ## 3000 - Grafana

        #2108  ## 2108 - Suwayomi Server
        #4567  ## 4567 - Suwayomi Server


        #4500  ## 4500 - u9fs

        # --- 2. SUNSHINE & MOONLIGHT PORTS ---
        47984
        47989
        47990  ## 47990 - Moonlight Web UI HTTPS
        48010  ## 48010 - Sunshine Server

        ### Base
        80
        443
      ];

      allowedUDPPorts = [ 
        config.services.tailscale.port
      ];
    };
  };

  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  #### Nvidia settings
  hardware = {
    # Enable graphic card
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia-container-toolkit.enable = true;

    nvidia = {

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

  };

  virtualisation.docker = {
    enable = true;
    #enableNvidia = true;
  };

  systemd.services.docker.path = [ pkgs.nvidia-container-toolkit ];

  # Correct way to set Surface-specific options
  #hardware.surface = { # This is the main attribute set for Surface hardware
  #  enable = true; # Enables the core Surface hardware support (kernel patches etc.)
  #  ipts.enable = true; # Enables touch and pen support
  #};

  #services.surface-control.enable = true; # This remains a separate service
  
    # Keep your increased swap and zramSwap settings
  swapDevices = [
    { device = "/swapfile"; size = 8192; } # Or 16384 for 16GB
  ];
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    priority = 100;
  };


  #### Sleep schedule
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

  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ## User groups

  users.users.tarobutter = {
    description = "Tarot D. Butter";
    extraGroups = [
      "input"
      "networkmanager"
      "systemd-journal"
      "wheel"
      "docker"
      "surface-control"
    ];
    isNormalUser = true;
    shell = pkgs.bash;
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

    fastfetch

    openssl
    nettools
    rustscan

    coreutils

    exfatprogs
    parted
    btrfs-progs
    lsof

    docker-compose

    nvidia-container-toolkit

    efibootmgr

    kando
    tmux
    inetutils

    intel-media-driver
    nvidia-vaapi-driver
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







  






