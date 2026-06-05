
{
  pkgs,
  self,
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
    self.nixosModules.games
    # self.nixosModules.guacamole

    self.nixosModules.grafana

    self.nixosModules.homepage

    self.nixosModules.jellyfin

    self.nixosModules.moonlight

    self.nixosModules.komga

    self.nixosModules.localai

    # self.nixosModules.plan9
    self.nixosModules.prometheus
    self.nixosModules.rustdesk

    self.nixosModules.suwayomi

    # nixosCosmicModule
    
    
    # ./modules/plan9.nix
    # ./modules/rustdesk.nix


  ];

  users.groups.media = {
    gid = 995; # Pick a unique ID or let NixOS auto-assign
  };

  hardware.enableRedistributableFirmware = true;
  services.udisks2.enable = true;

  services.nginx = {
  enable = true;
    virtualHosts."_" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:3111";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };


  boot = {
    kernelModules = [ 
      "xhci_pci" "usb_storage" "usbhid" "sd_mod"
      "ntfs3" "ext4" "btrfs" "vfat" "exfat"
    ];

    initrd.kernelModules = [ 
      "nvidia" 
      "nvidia_modeset" 
      "nvidia_uvm" 
      "nvidia_drm" 
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


  i18n.defaultLocale = "en_US.UTF-8";

  security.rtkit.enable = true;

  services = {
    
    # Enable the Cosmic Desktop Environment
    # services.desktopManager.cosmic.enable = true;
    # services.displayManager.cosmic.enable = false;  # Use the Gnome display Manager instead. 
    desktopManager.gnome.enable = true; 
    displayManager.gdm.enable = true;


    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    ## Open ssh
    openssh = {
      enable = true;

    };
    

    pipewire = {
      enable = true;

      pulse.enable = true;
      alsa.enable = true;
      jack.enable = true;
    };

    printing.enable = true;

    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };

  system.stateVersion = "25.05";

  time.timeZone = "America/Anchorage";
}
