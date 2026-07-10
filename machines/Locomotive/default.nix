## machines/Locomotive/default.nix
{
  inputs, pkgs, self, lib, ...
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
    users.tarobutter = {
      profiles.gaming.enable = lib.mkForce false;
      profiles.communications.enable = lib.mkForce false;
      profiles.shortstack.enable = false;
    };
  };

  ecosystem.users.tarobutter.enable = true;

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
