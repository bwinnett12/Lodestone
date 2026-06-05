
{ config, lib, pkgs, inputs, nixosCosmicModule, home-manager, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ]; 

    ## Settings for cosmic
    # substituters = [ "https://cosmic.cachix.org/" ];
    # trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
  };

  users.users.tarobutter = {
    description = "Tarot D. Butter";
    extraGroups = [
      "input"
      "networkmanager"
      "systemd-journal"
      "wheel"
      "docker"
      "video"
      "render"
      "jellyfin"
      "storage-Orchid"
      "storage-Yarrow"
      "storage-Tulip"
      "media"
      "rustdesk"
      "uinput"
    ];
    isNormalUser = true;
    shell = pkgs.bash;
  };

  nixpkgs.config.allowUnfree = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.tailscale.enable = true;

  networking = {
    
    hostName = "Island";
    #interfaces.enp0s31f6.useDHCP = true;

    interfaces.enp0s31f6.ipv4.addresses = [{
      address = "192.168.100.2";
      prefixLength = 24;
    }];
    interfaces.enp0s31f6.useDHCP = false;

    defaultGateway = "192.168.100.1";
    nameservers = [ "1.1.1.1" "8.8.8.8" "100.100.100.100" ];

    networkmanager.enable = true;

    firewall = {

      allowedUDPPorts = [ 
        config.services.tailscale.port
      ];

      enable = true;
      checkReversePath = "loose";
      trustedInterfaces = [ "tailscale0" ];
      allowedTCPPorts = [ 
        8080  ## 8080 - LocalAI
        8081  ## 8081 - LocalAI      
        8090  ## 8080 - LocalAI

        4822  ## 4822 - Guacamole
        3389  ## 3389 - Guacamole

        2104  ## 2104 - Komga

        9000  ## 9000 - Prometheus
        9090  ## 9090 - Prometheus
        2117  ## 2117 - Grafana

        2108  ## 2108 - Suwayomi Server
        4567  ## 4567 - Suwayomi Server

        4500  ## 4500 - u9fs


        2111  ## 2111 - Calibre Server
        8083  ## 8083 - Calibre Web

        2112  ## 2112 - Message
        2113  ## 2113 - Mailroom

        3000  ## 3000 - Homepage

        47990  ## 47990 - Moonlight
        48010  ## 48010 - Sunshine
        47984  ## 48010 - Sunshine
        47989  ## 48010 - Sunshine
        


        3111  ## Anki 
        3112  ## Anki 
        3113  ## Anki 


        5150  ## Mailroom
        2000  ## filebrowser


        21115  ## Rustdesk
        21116  ## Rustdesk
        21117  ## Rustdesk
        21118  ## Rustdesk
        21119  ## Rustdesk

        80 
        443
      ];
    };
  };


  #### Sleep schedule
  ## Systemd configuration for disabling auto sleep
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };



  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  #### Nvidia settings
  ## Don't integrate quite yet. Don't open that can of worms quite yet.

  hardware = {
    # Enable graphic card
    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        intel-media-driver # For Intel QuickSync (newer CPUs)
        intel-vaapi-driver   # For older Intel CPUs
        libva-vdpau-driver
        libvdpau-va-gl
        intel-compute-runtime # Optional: for OpenCL tone mapping
      ];
    };

    nvidia-container-toolkit.enable = true;

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;
      open = false; # Open-source drivers are for RTX 20-series and newer; false to use the proprietary (closed-source) driver
      nvidiaSettings = true;
      powerManagement.enable = false;
    };
  };

  ## Enable the NVIDIA driver for Xorg and load the kernel module
  services.xserver.videoDrivers = [ "nvidia" ];

  virtualisation.docker = {
    enable = true;
    # enableNvidia = true;
  };

  systemd.services.docker.path = [ pkgs.nvidia-container-toolkit ];

  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ## Programs
  programs.firefox.enable = true;

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

    docker-compose

    nvidia-container-toolkit

    efibootmgr

    tmux
    inetutils

    pciutils
    usbutils

    wlr-randr
  ];

  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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
