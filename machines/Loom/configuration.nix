
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
      package = config.boot.kernelPackages.nvidiaPackages.legacy_535;
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
  hardware.microsoft-surface = {
    ipts.enable = true;
    surface-control.enable = true;
    # kernelVersion = "stable"; # optional, defaults to "longterm"
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
    libinput
    libcamera
    libcamera-qcam
    docker-compose
    efibootmgr
    intel-media-driver
    nvidia-vaapi-driver
    nvidia-container-toolkit
    surface-control
  ];
  system.stateVersion = "25.05"; # Did you read the comment?

}
