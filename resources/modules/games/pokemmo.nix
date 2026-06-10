#### Pokemmo Module
{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
     pkgs.pokemmo-installer

  ];


}
