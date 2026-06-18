{ config, pkgs, lib, ... }:
{
  programs.home-manager.enable = true;

  home = {
    username = "tarobutter";
    homeDirectory = "/home/tarobutter";
    stateVersion = "24.05";

    packages = with pkgs; [
      fastfetch
      htop
      exfatprogs
    ];
  };

  programs = {
    bash.enable = true;

    git = {
      enable = true;
      settings.user = {
        name = "W. Winnett";
        email = "bwinnett12@gmail.com";
      };
    };
  };
}