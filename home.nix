
{ config, pkgs, home-manager, ... }:

{

  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  # Let Home Manager install and manage itself.
  # programs.home-manager.enable = true;



  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ## User information
  home.username = "tarobutter";
  home.homeDirectory = "/home/tarobutter";




  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ## Programming
  programs.bash.enable = true;



  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ## Github information
  programs.git = {
    enable = true;
    userName = "W. Winnett";
    userEmail = "bwinnett12@gmail.com";
  };



  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  home.packages = with pkgs; [
    htop
    neofetch
    exfatprogs
    kando
  ];


  #flake.homeModules = {
  #  "modules/" = ./modules;
  #  "modules/academic" = ./modules;
  #  "modules/communications/personal" = ./modules/communications/personal;
  #  "modules/communications/professional" = ./modules/communications/professional;
  #};


  #### ~~~~~~~~~
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";
}