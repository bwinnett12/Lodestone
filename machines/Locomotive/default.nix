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
      profiles.development.enable = lib.mkForce false;
    };
  };

  ecosystem.display.enable = false;

  ecosystem.users.tarobutter.enable = true;

  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  services = {
    getty.autologinUser = "tarobutter";
  };
  system.stateVersion = "25.11";
}
