
{
  inputs,
  pkgs,
  self,
  ...
}: 
{ 
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix

    self.ecosystem.citizens
    self.ecosystem.common

    self.nixosModules.go2rtc
    self.nixosModules.prometheus

    # self.nixosModules.hosts

    self.inputs.home-manager.nixosModules.home-manager

    # inputs.mailroom.nixosModules.default
  ];

    ## Profiles:
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit self; };
  };

  ecosystem.users.tarobutter.enable = true;
  profiles.shortstack.enable = false;
  profiles.communications = {
        enable = false;
      };
      profiles.gaming.enable = false;


  nix.settings.trusted-users = [ "root" "tarobutter" ];
  

  hardware.enableRedistributableFirmware = true;

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  security.rtkit.enable = true;

  services = {
    getty.autologinUser = "tarobutter";
    openssh.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
      };
    };

    # Keep if Locomotive does audio capture (Scarlett 2i2 / go2rtc)
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      jack.enable = true;
    };

    printing.enable = true;
    tailscale.enable = true;
    udisks2.enable = true;
  };

  system.stateVersion = "25.11";
  time.timeZone = "America/Anchorage";
}
