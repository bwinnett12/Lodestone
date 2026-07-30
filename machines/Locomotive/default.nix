## machines/Locomotive/default.nix
{
  inputs, pkgs, self, lib, ...
}: 
{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix

    self.nixosModules.go2rtc
    self.nixosModules.anki
    self.nixosModules.prometheus
    # inputs.mailroom.nixosModules.default
    self.nixosModules.mailroom
    self.nixosModules.homepage # <- #TODO Remove the module itself or repurpose into extending mailroom
    self.nixosModules.gitea
    self.nixosModules.pihole
    self.nixosModules.grafana
  ];

  services.calibre-server.enable = true;
  # services.calibre-web.enable = false;

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

  ecosystem = {
    display.enable = false;
    users.tarobutter.enable = true;
  };

  ## TODO - move this to configuration file
  services.u9fs-server = {
    enable      = true;
    tailscaleIP = "100.106.125.87"; # ipv4 of Locomotive
    exportPath  = "/storage/Orchard";
    port        = 4500;
  };

  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  services = {
    getty.autologinUser = "tarobutter";
  };
  system.stateVersion = "25.11";
}
