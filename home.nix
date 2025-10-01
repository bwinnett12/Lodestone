{ config, pkgs, ... }:

{
  # Set your state version for Home Manager
  home.stateVersion = "24.05"; # Match your NixOS release

  home.packages = with pkgs; [
    htop
    neofetch
    exfatprogs
  ];

  programs.bash.enable = true;
  # programs.zsh.enable = true; 

  # Other user-level configurations will go here
}
