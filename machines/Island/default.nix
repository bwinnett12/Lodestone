
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
    self.inputs.home-manager.nixosModules.home-manager

    #self.nixosModules.mailroom
    self.nixosModules.anki
    self.nixosModules.calibre-server
 #   self.nixosModules.filebrowser
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
    users.tarobutter = { config, lib, pkgs, ... }: {
      imports = [
        ../../resources/home/default.nix
        ../../configurations/users/tarobutter
      ];
      profiles.communications = {
        enable = true;
        professional = true;
        gaming = true;
      };
      profiles.gaming.enable = true;
    };
  }; 

  users.groups.media = {
    gid = 995; # Pick a unique ID or let NixOS auto-assign
  };

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
    "qtwebengine-5.15.19"
  ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];

    initrd.kernelModules = [ 
      "nvidia" 
      "nvidia_modeset" 
      "nvidia_uvm" 
      "nvidia_drm" 
    ];


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


  i18n.defaultLocale = "en_US.UTF-8";
  security.rtkit.enable = true;

  services = {

    # Enable the Cosmic Desktop Environment
    # services.desktopManager.cosmic.enable = true;
    # services.displayManager.cosmic.enable = false;  # Use the Gnome display Manager instead. 
    desktopManager.gnome.enable = true; 
    displayManager.gdm.enable = true;


    libinput.enable = true;
    nginx.enable = true;
    openssh.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      jack.enable = true;
    };
    printing.enable = true;
    tailscale = {
      enable = true; 
      permitCertUid = "nginx";
    };
    udisks2.enable = true;
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
  time.timeZone = "America/Anchorage";
}
