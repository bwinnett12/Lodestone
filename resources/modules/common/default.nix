# resources/modules/common/default.nix
{ config, lib, pkgs, self, inputs, ... }: {

  imports = [
    ./networking.nix

    self.ecosystem.citizens.humans
    self.ecosystem.citizens.functionaries
    self.ecosystem.citizens.upgraded
    self.ecosystem.display

    self.nixosModules.hosts
    self.nixosModules.plan9

    self.inputs.home-manager.nixosModules.home-manager
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Anchorage";
  
  ## General Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "tarobutter" ];
  };
  nixpkgs.config.allowUnfree = true;
  security.rtkit.enable = true;

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
    fastfetch
    git
    vim
    wget
    tree
    tmux

    exfatprogs
    parted
    btrfs-progs
    lsof
    usbutils
  ];
}