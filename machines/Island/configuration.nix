
{ config, lib, pkgs, inputs, nixosCosmicModule, ... }:
{
  
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  networking = {
    defaultGateway = "192.168.100.1";
    hostName = "Island";

    interfaces.enp0s31f6 = {
      ipv4.addresses = [{
        address = "192.168.100.2";
        prefixLength = 24;
      }];
      useDHCP = false;
    };
  };

  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  #### Nvidia settings
  ## Don't integrate quite yet. Don't open that can of worms quite yet.
  # Core Graphics Infrastructure
  hardware = {
    enableRedistributableFirmware = true;

    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };

    nvidia-container-toolkit.enable = true;
    nvidia = {
      modesetting.enable = true;      
      open = false; 
      nvidiaSettings = true;
      powerManagement.enable = false; 
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };


  virtualisation.docker.enable = true; 

  systemd = {
    services = {
      docker.path = [ pkgs.nvidia-container-toolkit ];
      
      ethtool-gro = {
        description = "Enable UDP GRO forwarding on enp0s31f6";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.ethtool}/bin/ethtool -K enp0s31f6 rx-udp-gro-forwarding on";
        };
      };
      systemd-timesyncd.wantedBy = [ "multi-user.target" ];
    };

    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };

  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ## Programs
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vlc
    docker-compose
    nvidia-container-toolkit
    efibootmgr
    pciutils
    wlr-randr
  ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
