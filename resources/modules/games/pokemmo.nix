#### Pokemmo Module
{ config, pkgs, inputs, ... }:
{
  options.gaming.pokemmo.enable = lib.mkOption {
    type    = lib.types.bool;
    default = true;
    description = "Install PokeMMO via the gaming module.";
  };

  config = lib.mkIf config.gaming.pokemmo.enable {
    environment.systemPackages = [ pkgs.pokemmo-installer ];
  };
}