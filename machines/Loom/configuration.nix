
# https://search.nixos.org/options: NixOS manual (`nixos-help`)
{ config, lib, pkgs, inputs, nixosCosmicModule, ... }:

{
  networking = {
    hostName = "Loom";
    useDHCP = false;
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

  fonts.fontconfig.subpixel.rgba = "none";  # for HiDPI, subpixel is counterproductive

  virtualisation.docker = {
    enable = true;
    #enableNvidia = true;
  };

  systemd.services.docker.path = [ pkgs.nvidia-container-toolkit ];

  hardware.microsoft-surface.kernelVersion = "longterm";
  
  # Keep your increased swap and zramSwap settings
  swapDevices = [
    { device = "/swapfile"; size = 8192; } # Or 16384 for 16GB
  ];
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    priority = 100;
  };

  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ## Programs

  programs.firefox = {
    enable = true; 
    preferences = {
      # disable libadwaita theming for Firefox
      "widget.gtk.libadwaita-colors.enabled" = false;
    };
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vlc
    libcamera
    libcamera-qcam
    docker-compose
    efibootmgr
    intel-media-driver
    nvidia-vaapi-driver
    nvidia-container-toolkit
  ];

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
