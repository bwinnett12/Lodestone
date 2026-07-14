{
  pkgs,
  lib,
  self,
  inputs,
  ...
}:
{ 
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix

    inputs.nixos-hardware.nixosModules.microsoft-surface-common
    self.nixosModules.prometheus
    self.nixosModules.anki

    self.nixosModules.moonlight
    #self.nixosModules.scarlet2i2

    self.nixosModules.frontpage
    self.nixosModules.gitea
    # nixosCosmicModule

    self.nixosModules.grafana
    #self.nixosModules.localai
    self.nixosModules.jellyfin
  ];

  services.u9fs-client = {
    enable      = true;
    serverIP    = "100.82.185.26"; # ipv4 of Island
    mountPoint  = "/storage/Orchard";
    port        = 4500;
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 4500 ];

  ## Profiles:
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit self; };
    users.tarobutter = {
      profiles.gaming.enable = lib.mkForce true;
      profiles.communications.enable = lib.mkForce true;
      profiles.development.enable = lib.mkForce true;
      # profiles.shortstack.enable = false;
    };
  };

  ecosystem.users.tarobutter.enable = true;
  
  nixpkgs.config = {
    # allowUnfree = true;

    allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "cuda"
      # Other Nvidia packages
    ];

    permittedInsecurePackages = [
      "qtwebengine-5.15.19"
      "openssl-1.1.1w"
    ];
  };

  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ####### Boot settings
  boot = {
    kernelModules = [ "ntfs3" "ext4" "btrfs" "vfat" "exfat" ];
    #kernelPackages = lib.mkForce pkgs.linux-surface;
    # boot.kernelPackages = lib.mkForce pkgs.linuxKernel.kernels.linux_surface_stable;  # confirm exact name
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot.enable = true;
    };
  };

  #environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

 services = {

    # Enable the Cosmic Desktop Environment
    #displayManager.cosmic-greeter.enable = true;
    #desktopManager.cosmic.enable = true;
    #system76-scheduler.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    iptsd.enable = true;

    logind = {
      lidSwitch = "suspend";              # closing lid while on battery → sleep, standard laptop behavior
      lidSwitchExternalPower = "ignore";  # plugged in at a desk → stays awake even with lid closed, useful for a 2-in-1 docked with an external display, or just running background tasks
      lidSwitchDocked = "ignore";         # if you ever use a dock/external monitor setup
    };
    
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      wacom.enable = true;
      videoDrivers = [ "nvidia" ];
      resolutions = [{ x = 1920; y = 1280; }];
    };
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
  };
  system.stateVersion = "25.05";
  hardware.enableRedistributableFirmware = true;

  systemd.targets = {
    sleep.enable = true;
    suspend.enable = true;
    hibernate.enable = true;
    hybrid-sleep.enable = true;
  };

}
