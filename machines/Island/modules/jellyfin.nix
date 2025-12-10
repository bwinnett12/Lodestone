#### Jellyfin server
{ config, pkgs, ... }:

{
  # Enable the Jellyfin service
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    
    user = "tarobutter";  # todo - Provide a better solution for this
    group = "jellyfin";

    dataDir = "/storage/Yarrow/temp";
    configDir = "/storage/Orchid/temp";
    logDir = "/storage/Nettle/temp";
    # cacheDir = ""; # todo - Set this to be the SSD?

  };
  
}
