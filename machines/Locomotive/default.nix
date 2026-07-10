## machines/Locomotive/default.nix
{
  inputs, pkgs, self, ...
}: 
{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix

    self.nixosModules.go2rtc
    self.nixosModules.prometheus
    self.nixosModules.hosts
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

  services = {
    getty.autologinUser = "tarobutter";
  };
  system.stateVersion = "25.11";
}
