{
  pkgs,
  self,
  ...
}: 
{ 
  imports = [
    ./hardware-configuration.nix
	./configuration.nix

    # self.nixosModules.locale

  ];
  
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };
  networking = {
    # firewall.checkReversePath = "loose";
    hostName = "Island";
    networkmanager.enable = true;
  };

  programs.steam.enable = true;
  security.rtkit.enable = true;
  services = {

    # tailscale.enable = true;

    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };


  system.stateVersion = "25.05";

  users.users.tarobutter = {
    description = "Tarot D. Butter";
    extraGroups = [
      "input"
      "networkmanager"
      "systemd-journal"
      "wheel"
    ];
    isNormalUser = true;
    shell = pkgs.bash;
  };
}