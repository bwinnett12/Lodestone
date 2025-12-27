#### Gaming Module
{ config, pkgs, inputs, ... }:

{
	programs.steam = {
		enable = true;	
	};


	environment.systemPackages = with pkgs; [
		pkgs.runescape
		pkgs.runelite
	];


}
