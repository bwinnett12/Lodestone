## Gaming
{
  self, config, lib, pkgs,
  ...
}: let
  cfg = config.profiles.gaming;
in {
  options.profiles.gaming = {
    enable = lib.mkEnableOption "Gaming profile";

    ## Pokemmo
    pokemmo = lib.mkOption {
      type    = lib.types.bool;
      default = true;
      description = "Install PokeMMO";
    };

    ## Runescape
    runescape = lib.mkOption {
      type    = lib.types.bool;
      default = true;
      description = "Install Runescape through `runelite`";
    };

    ## Steam
    steam = lib.mkOption {
      type    = lib.types.bool;
      default = true;
      description = "Install Steam";
    };
  };

  config = lib.mkIf cfg.enable {
    # Module-backed options
    gaming.pokemmo.enable = lib.mkDefault cfg.pokemmo;
    hardware.steam-hardware.enable = lib.mkDefault cfg.steam;
    programs.steam.enable          = lib.mkDefault cfg.steam;

    # Inline packages (no dedicated module)
    home.packages = 
    []
    ++ lib.optionals cfg.runescape [ pkgs.runelite pkgs.bolt-launcher ]
    ++ lib.optionals cfg.pokemmo [ pkgs.pokemmo-installer ]
      ++ [
        pkgs.airshipper
        pkgs.protontricks
        
        pkgs.winetricks
        bolt-launcher
      ];
  };
}