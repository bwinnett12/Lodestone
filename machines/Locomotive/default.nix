
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
    self.nixosModules.go2rtc
    self.nixosModules.prometheus
    self.inputs.home-manager.nixosModules.home-manager

    # inputs.mailroom.nixosModules.default
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit self; };
    users.tarobutter = { config, lib, pkgs, ... }: {
      imports = [
        ../../resources/home/default.nix
        ../../configurations/users/tarobutter
      ];
      profiles.communications.enable = lib.mkForce false;
      profiles.gaming.enable = lib.mkForce false;
    };
  }; 

  users.groups.media = {
    gid = 995; # Pick a unique ID or let NixOS auto-assign
  };

  hardware.enableRedistributableFirmware = true;
  services.udisks2.enable = true;


  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];


  i18n.defaultLocale = "en_US.UTF-8";

  security.rtkit.enable = true;

  services = {
    getty.autologinUser = "tarobutter";
    openssh.enable = true;

    # Keep if Locomotive does audio capture (Scarlett 2i2 / go2rtc)
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      jack.enable = true;
    };

    printing.enable = true;
  };

    

    # xserver = {
    #   enable = true;
    #   desktopManager.xfce.enable = true;
    #   displayManager.lightdm = {
    #     enable = true;
    #     extraConfig = ''
    #       xserver-command=X -core -nocursor
    #       '';
    #     };

    #   xkb = {
    #     layout = "us";
    #     variant = "";
    #   };
    # };

  system.stateVersion = "25.11";

  time.timeZone = "America/Anchorage";
}
