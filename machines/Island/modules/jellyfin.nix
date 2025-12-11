#### Jellyfin server
{ config, pkgs, ... }:

{
  # Enable the Jellyfin service
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    
    user = "tarobutter";  # todo - Provide a better solution for this
    group = "users";  # todo - Provide a better solution for this

    dataDir = "/storage/Yarrow/temp";  # todo - Re-implement with 9p system
    configDir = "/storage/Orchid/temp";  # todo - Re-implement with 9p system
    logDir = "/storage/Nettle/temp";  # todo - Re-implement with 9p system
    # cacheDir = ""; # todo - Set this to be the SSD?

  };

  
  
}
