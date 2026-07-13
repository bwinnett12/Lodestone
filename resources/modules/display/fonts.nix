{ self, pkgs, inputs, lib, ... }:
{
  fonts.packages = with pkgs; [
    jetbrains-mono
  ];

  fonts.fontconfig.defaultFonts = {
    sansSerif   = [ "Arvo" ];
    serif       = [ "Arvo" ];
    monospace   = [ "JetBrainsMono Nerd Font" ];
  };
}
