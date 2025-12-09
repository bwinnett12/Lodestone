#### Jellyfin server
{ config, pkgs, ... }:

{
  # Enable the Jellyfin service
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    
    group = "jellyfin";
    dataDir = "/storage/Yarrow/temp";
    configDir = "/storage/Orchid/temp";

  };
  
}
  
