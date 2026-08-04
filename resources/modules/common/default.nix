# resources/modules/common/default.nix
{ config, lib, pkgs, self, inputs, ... }: {

  imports = [
    self.ecosystem.citizens.humans
    self.ecosystem.citizens.functionaries
    self.ecosystem.citizens.upgraded

    self.ecosystem.networking.common
    self.ecosystem.networking.hosts
    self.ecosystem.environments.neovim
    self.ecosystem.power

    self.ecosystem.storage.u9fs
    self.ecosystem.storage.drives
    
    self.nixosModules.display

    self.inputs.home-manager.nixosModules.home-manager
    self.inputs.sops-nix.nixosModules.sops


    self.nixosModules.calibre

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
    git-annex

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