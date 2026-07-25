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

    kitty.enable = true;

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

  xdg.configFile."cosmic/com.system76.CosmicComp/v1/outputs".text = ''
    ({"card1-eDP-1": (
      enabled: true,
      mode: Some((
        size: (w: 1920, h: 1280),
        refresh: Some(60000),
      )),
      scale: 1.5,
      transform: Normal,
      vrr: false,
      max_active_hint: false,
    )})
  '';

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
