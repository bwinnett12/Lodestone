# resources/modules/common/default.nix
{ config, lib, pkgs, self, ... }: {

  imports = [
    ./networking.nix
    self.ecosystem.citizens.functionaries
    self.nixosModules.hosts
  ];

  ## General Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "tarobutter" ];
  };
  nixpkgs.config.allowUnfree = true;
  security.rtkit.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Anchorage";

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      jack.enable = true;
    };
    
    printing.enable = true;
    udisks2.enable = true;
  };

  environment.systemPackages = with pkgs; [
    coreutils
    git
    neofetch
    nettools
    openssl
    openssh
    vim
    wget
  ];
}