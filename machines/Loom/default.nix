
# TODO - Improve this 

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

    # self.nixosModules.grafana
    # self.nixosModules.jellyfin
    # self.nixosModules.suwayomi
    # self.nixosModules.komga
    # self.nixosModules.localai
    #self.nixosModules.plan9
    self.nixosModules.prometheus
    self.nixosModules.moonlight
    self.nixosModules.scarlet2i2


    # nixosCosmicModule

  ];

  ## Profiles:
  profiles.communications.enable = true;
  profiles.communications.professional = true;
  profiles.communications.gaming = true;
  profiles.gaming.enable = true;

  #nixpkgs.config.permittedInsecurePackages = [
  #  "openssl-1.1.1w"
  #];

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


    caddy.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    openssh.enable = true;

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
      videoDrivers = [ "nvidia" ];
    };
  };

  system.stateVersion = "25.05";

  time.timeZone = "America/Anchorage";
}


