#### Gaming Module
{ config, pkgs, inputs, ... }:

{
  programs.steam = {
	enable = true;	
  };


  environment.systemPackages = with pkgs; [
	pkgs.bolt-launcher
	# pkgs.runescape

	pkgs.runelite
  ];


}
