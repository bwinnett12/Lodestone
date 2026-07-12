
{
  pkgs,
  self,
  lib,
  inputs,
  ...
}: 
{ 
  imports = [
    ./hardware-configuration.nix
    ./drives.nix
    ./configuration.nix
    
    #self.nixosModules.mailroom
    self.nixosModules.anki
    self.nixosModules.calibre-server
 #   self.nixosModules.filebrowser
    self.nixosModules.gitea
    self.nixosModules.go2rtc
    self.nixosModules.grafana
    self.nixosModules.homepage
    self.nixosModules.jellyfin
    self.nixosModules.moonlight
    self.nixosModules.komga
    self.nixosModules.localai
    # self.nixosModules.plan9
    self.nixosModules.prometheus
    self.nixosModules.suwayomi
    # nixosCosmicModule
  ];

  ## Profiles:
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit self; };
  };

  ecosystem.users.tarobutter.enable = true;
  
  ## TODO - move this to configuration file
  services.u9fs-server = {
    enable      = true;
    tailscaleIP = "100.82.185.26"; # ipv4
    exportPath  = "/storage/Orchard";
    port        = 4500;
  };
  
  ## TODO - Move this to a configuration file
  users.groups.media = {
    gid = 995; # Pick a unique ID or let NixOS auto-assign
  };

  nixpkgs.config = {
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

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];

    initrd.kernelModules = [ 
      "nvidia" 
      "nvidia_modeset" 
      "nvidia_uvm" 
      "nvidia_drm" 
    ];

    kernel.sysctl = {
      "net.ipv6.conf.all.forwarding" = 1;
    };


    kernelModules = [ 
      "xhci_pci" "usb_storage" "usbhid" "sd_mod"
      "ntfs3" "ext4" "btrfs" "vfat" "exfat"
    ];
    kernelParams = [
      "tpm_tis.interrupts=0" 
      "pci=noaer"
    ];

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = true;
        configurationLimit = 15;
      };
    };
  };

  services = {

    desktopManager.gnome.enable = true; 
    displayManager.gdm.enable = true;

    libinput.enable = true;

    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };

  system.stateVersion = "25.05";
}
