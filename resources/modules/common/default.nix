# resources/modules/common/default.nix
{ config, lib, pkgs, self, ... }: {

  imports = [
	./networking.nix
	./exports.nix
	self.ecosystem.citizens.functionaries
	self.nixosModules.hosts ## TODO - Replace this
  ];

  ## General Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "tarobutter" ];
  };
  nixpkgs.config.allowUnfree = true;

  ## Common settings that I apply to each device
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Anchorage";

  environment.systemPackages = with pkgs; [
	mangohud
	protonup-qt
  ];
}