# resources/modules/gaming/default.nix
{ config, lib, pkgs, ... }:
let
  cfg = config.profiles.gaming;
in {
  options.profiles.gaming.enable = lib.mkEnableOption "system-level gaming support";

  imports = [
    self.nixosModules.games
  ];

  config = lib.mkIf cfg.enable {
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = false;
      };
      gamemode.enable = true;
    };



    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;  # needed for Steam
    };

    environment.systemPackages = with pkgs; [
      mangohud
      protonup-qt
    ];
  };

}