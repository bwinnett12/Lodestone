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
    self.inputs.home-manager.nixosModules.home-manager
    self.nixosModules.prometheus
    self.nixosModules.moonlight
    #self.nixosModules.scarlet2i2
    self.nixosModules.games
    self.nixosModules.plan9
    # nixosCosmicModule
  ];


  services.u9fs-client.enable = true;
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 4500 ];


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


  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "tarobutter" ];
  };

  nixpkgs.config = {
    allowUnfree = true;

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
  #config.microsoft-surface.surface-control.enable = true;


  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ####### Boot settings
  boot = {
    kernelModules = [ "ntfs3" "ext4" "btrfs" "vfat" "exfat" ];
    kernelPackages = lib.mkForce pkgs.linuxPackages_6_6;
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot.enable = true;
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

    ## Crucial for lilyinstarlight/nixos-cosmic for faster builds:
    #nix.settings = {
    #  substituters = [ "https://cosmic.cachix.org/" ];
    #  trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
    # };

    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
      };
    };

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

  # Systemd login configuration
  #  logind = {
  #  lidSwitchExternalPower = "ignore";
  #  lidSwitchBattery = "ignore";
  #};


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
    timesyncd = {
      enable = true;
      servers = [ "time.cloudflare.com" "pool.ntp.org" ];
    };
    udisks2.enable = true;

    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      videoDrivers = [ "nvidia" ];
    };
  };

  system.stateVersion = "25.05";
  time.timeZone = "America/Anchorage";
}