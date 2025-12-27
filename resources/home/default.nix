
{ config, pkgs, home-manager, ... }:

{

  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  # Let Home Manager install and manage itself. 
  # TODO - Is this best to declare each time or 
  programs.home-manager = {
    enable = true;
    useUserPackages = true;
  };

  home = {
    username = "tarobutter";
    homeDirectory = "/home/tarobutter";
    useUserPackages = true;

    packages = with pkgs; [
      htop
      neofetch
      exfatprogs
      kando
    ];
  };


  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ## User information

  users.users.tarobutter = {
    description = "Tarot D. Butter";
    extraGroups = [
      "input"
      "networkmanager"
      "systemd-journal"
      "wheel"
      "docker"
    ];
    isNormalUser = true;
    shell = pkgs.bash;
  };



  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ## Programming
  programs = {

    bash = {
      enable = true;
    };

    ## Github information
    git = { 

      enable = true;
      settings.user = {
        name = "W. Winnett";
        email = "bwinnett12@gmail.com";
      };
    };
  }; 


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
