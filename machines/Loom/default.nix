{ pkgs, lib, self, inputs, ... }:
{ 
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix

    inputs.nixos-hardware.nixosModules.microsoft-surface-common
    self.nixosModules.prometheus
    self.nixosModules.anki

    # self.nixosModules.moonlight
    #self.nixosModules.scarlet2i2

    self.nixosModules.frontpage
    # nixosCosmicModule
    self.nixosModules.academic

    self.nixosModules.grafana
    self.nixosModules.localai
    self.nixosModules.jellyfin

    # self.ecosystem.roles.builder
    
  ];

  ecosystem.display.enable = true;
  # ecosystem.display.gnome.enable = true;
  ecosystem.display.cosmic.enable = true;

  ecosystem.power.enable = true;
  ecosystem.power.portable.enable = true;

  services.u9fs-client = {
    enable      = true;
    serverIP    = "100.106.125.87"; # ipv4 of Locomotive
    mountPoint  = "/storage/Orchard";
    port        = 4500;
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 4500 ];

  nix.settings.extra-platforms = [ "aarch64-linux" ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

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

    #desktopManager.gnome.enable = true;
    #displayManager.gdm.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;  # TODO - Move to table module
    iptsd.enable = true;

    logind = {
      settings.Login = { 
        HandleLidSwitchDocked = "ignore";   # if you ever using a dock/external monitor setup
        HandleLidSwitchExternalPower = "ignore";  # plugged in at a desk → stays awake even with lid closed, useful for a 2-in-1 docked with an external display, or just running background tasks
        HandleLidSwitch = "suspend"; # closing lid while on battery → sleep, standard laptop behavior
        };
    };

    

    xserver = {
      wacom.enable = true;
      videoDrivers = [ "nvidia" ];
      # resolutions = [{ x = 1920; y = 1280; }]; # TODO - Implement for Gnome
    };
    colord.enable = true;
    thermald.enable = true;
  };
  system.stateVersion = "25.05";

  hardware = {
    enableRedistributableFirmware = true;
    opentabletdriver = {
      enable = true; 
      daemon.enable = true;
    };
  };


  # TODO - Make a sleep module
  systemd.targets = {
    sleep.enable = true;
    suspend.enable = true;
    hibernate.enable = true;
    hybrid-sleep.enable = true;
  };

}
