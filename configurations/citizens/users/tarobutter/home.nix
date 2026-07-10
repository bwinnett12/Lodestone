# configurations/users/tarobutter/home.nix
{ config, pkgs, lib, ... }: {
  imports = [
    ../../general
  ];

  profiles = {
    gaming = {
      enable = true;
      pokemmo = true;
      runescape = true;
    };
    communications = {
      enable = true;
      professional = true;
      gaming = true;
    };

	development = {
		enable = true;
		rust = true;
		julia = true;
	};
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
    home-manager.enable = true;
  };

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
}