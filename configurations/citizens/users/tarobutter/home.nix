# configurations/citizens/users/tarobutter/home.nix
{ config, pkgs, lib, ... }: {
  imports = [
    ../../../general
  ];

  profiles = {
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
    gaming = {
      enable = true;
      pokemmo = true;
      runescape = true;
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

    ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks."*" = {
        # re-declare whatever defaults you actually want to keep, e.g.:
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
      };
      matchBlocks."github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
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