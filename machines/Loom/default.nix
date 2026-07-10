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

    self.ecosystem.citizens
    self.ecosystem.common


    inputs.nixos-hardware.nixosModules.microsoft-surface-common
    self.inputs.home-manager.nixosModules.home-manager
    self.nixosModules.prometheus
    self.nixosModules.anki

    self.nixosModules.moonlight
    #self.nixosModules.scarlet2i2

    self.nixosModules.frontpage

    self.nixosModules.games
    self.nixosModules.plan9
    self.nixosModules.gitea
    # nixosCosmicModule

    # self.nixosModules.hosts

    self.nixosModules.grafana
    self.nixosModules.localai
    self.nixosModules.jellyfin



  ];

  services.u9fs-client = {
    enable      = true;
    serverIP = "100.82.185.26"; # ipv4 of Island
    mountPoint  = "/storage/Orchard";
    port        = 4500;
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 4500 ];

  ## Profiles:
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit self; };
  };

  ecosystem.users.tarobutter.enable = true;
  profiles.shortstack.enable = true;

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

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

  # Systemd login configuration
  #  logind = {
  #  lidSwitchExternalPower = "ignore";
  #  lidSwitchBattery = "ignore";
  #};


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
}