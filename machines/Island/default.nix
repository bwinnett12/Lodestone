
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
    self.inputs.home-manager.nixosModules.home-manager
    
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
    self.nixosModules.plan9
    # nixosCosmicModule


    self.nixosModules.hosts
  ];

  ## Profiles:
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit self; };
  };

  ecosystem.users.tarobutter.enable = true;
  profiles.shortstack.enable = true;

  
  ## TODO - move this to configuration file
  services.u9fs-server = {
    enable      = true;
    tailscaleIP = "100.82.185.26"; # ipv4
    exportPath  = "/storage/Orchard";
    port        = 4500;
  };
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 4500 ];

  ## TODO - Move this to a configuration file
  users.groups.media = {
    gid = 995; # Pick a unique ID or let NixOS auto-assign
  };

  ## TODO - Move this to a configuration file
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "tarobutter" ];
    ## Settings for cosmic
    # substituters = [ "https://cosmic.cachix.org/" ];
    # trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
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
    # Enable the Cosmic Desktop Environment
    # services.desktopManager.cosmic.enable = true;
    # services.displayManager.cosmic.enable = false;  # Use the Gnome display Manager instead. 
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
