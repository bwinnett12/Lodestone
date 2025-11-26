{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.gaming;
in {
  options.profiles.gaming = {
    enable = lib.mkEnableOption "gaming profile";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.airshipper
      pkgs.protontricks
      pkgs.runelite
      pkgs.teamspeak_client
      # see https://github.com/NixOS/nixpkgs/issues/78961
      pkgs.warzone2100
      pkgs.winetricks
    ];

  };
}