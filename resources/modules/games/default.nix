#### Gaming Module
{ config, pkgs, inputs, ... }:

{
  programs.steam = {
	  enable = true;	
  };

    imports = [ ./pokemmo.nix ];

  environment.systemPackages = with pkgs; [
	  pkgs.bolt-launcher
	  pkgs.runelite
  ];


}
