
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
    

    self.nixosModules.games
    self.nixosModules.guacamole
    self.nixosModules.jellyfin
    # self.nixosModules.suwayomi
    # self.nixosModules.komga
    self.nixosModules.localai
    # self.nixosModules.plan9

    # nixosCosmicModule
    
    
    # ./modules/plan9.nix
    # ./modules/rustdesk.nix


  ];

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  ### Options for docker
  virtualisation.docker.enable = true;
  virtualisation.docker.enableNvidia = true;

  hardware.nvidia.package = config.boot.kernelPackages.nvidia_x11;
  hardware.nvidia.modesetting.enable = true;


  boot = {
    kernelModules = [ "ntfs3" "ext4" "btrfs" "vfat" "exfat" ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot.enable = true;
    };
  };


  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    # firewall.checkReversePath = "loose";
    hostName = "Island";
    networkmanager.enable = true;
  };

  security.rtkit.enable = true;

  services = {
    
    # Enable the Cosmic Desktop Environment
    # services.desktopManager.cosmic.enable = true;
    # services.displayManager.cosmic.enable = false;  # Use the Gnome display Manager instead. 
    desktopManager.gnome.enable = true; 
    displayManager.gdm.enable = true;


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
    };
  };

  system.stateVersion = "25.05";

  time.timeZone = "America/Anchorage";
}
