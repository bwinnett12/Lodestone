## Gaming
{ config, lib, pkgs, ... }:
let
  cfg = config.profiles.gaming;
in {
  options.profiles.gaming = {
    enable = lib.mkEnableOption "Gaming profile";

    pokemmo = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install PokeMMO";
    };

    runescape = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Runescape through runelite";
    };

    steam = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Steam";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.steam.enable = lib.mkDefault cfg.steam;

    home.packages = 
      lib.optionals cfg.runescape [ pkgs.runelite pkgs.bolt-launcher ]
      ++ lib.optionals cfg.pokemmo [ pkgs.pokemmo-installer ]
      ++ [
        pkgs.airshipper
        pkgs.protontricks
        pkgs.winetricks
      ];
  };
}