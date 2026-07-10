
# https://search.nixos.org/options: NixOS manual (`nixos-help`)
{ config, lib, pkgs, inputs, nixosCosmicModule, ... }:

{
  ## Settings for cosmic
  # substituters = [ "https://cosmic.cachix.org/" ];
  # trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
  networking = {
    hostName = "Loom";

    networkmanager.enable = true;
    useDHCP = false;
    # interfaces.enp0s31f6.useDHCP = true; # Change this interface name if Loom's physical port is different!

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

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      powerManagement = { 
        enable = true;
      };

      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;
        intelBusId = "PCI:0:2:0";   # correct, 00:02.0 → PCI:0:2:0
        nvidiaBusId = "PCI:2:0:0";  # was PCI:1:0:0, correct is 02:00.0 → PCI:2:0:0
      };
    };
    nvidia-container-toolkit.enable = true;
  };

  powerManagement.cpuFreqGovernor = "powersave";  # or "schedutil"

  # TLP or auto-cpufreq for more nuanced control

  services = {
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
    colord.enable = true;
    power-profiles-daemon.enable = false;
    thermald.enable = true;
    xserver.wacom.enable = true;
  };

  fonts.fontconfig.subpixel.rgba = "none";  # for HiDPI, subpixel is counterproductive

  virtualisation.docker = {
    enable = true;
    #enableNvidia = true;
  };

  systemd = {
    services.docker.path = [ pkgs.nvidia-container-toolkit ];

    #### Sleep schedule
    ## Systemd configuration for disabling auto sleep
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };

  # microsoft-surface.surface-control.enable = true;

  # Correct way to set Surface-specific options
  hardware.microsoft-surface = {
  #  enable = true;
    #ipts.enable = true;      # touchscreen + stylus (IPTS protocol)
    #surface-control.enable = true;  # performance mode control CLI
    kernelVersion = "stable";
  };
  
    # Keep your increased swap and zramSwap settings
  swapDevices = [
    { device = "/swapfile"; size = 8192; } # Or 16384 for 16GB
  ];
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    priority = 100;
  };

  services.iptsd.enable = true;   # replaces hardware.microsoft-surface.ipts.enable


  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ## Programs
  
  programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vlc
    rustscan

    exfatprogs
    parted
    btrfs-progs
    lsof

    libcamera
    libcamera-qcam

    docker-compose

    nvidia-container-toolkit

    efibootmgr

    #kando
    tmux
    inetutils

    intel-media-driver
    nvidia-vaapi-driver
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