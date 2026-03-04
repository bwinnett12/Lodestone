#### Jellyfin server
{ config, pkgs, inputs, ... }:

{
  # Enable the Jellyfin service
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    
    user = "tarobutter";  # todo - Provide a better solution for this
    group = "users";  # todo - Provide a better solution for this

    dataDir = "/var/lib/jellyfin";  # TODO  - Re-implement with 9p system
    #configDir = "/storage/Yarrow/temp5";  # TODO  - Re-implement with 9p system
    #logDir = "/storage/Yarrow/temp6";  # TODO - Re-implement with 9p system
    # cacheDir = ""; # todo - Set this to be the SSD?
  };

  environment.systemPackages = with pkgs; [
      curl
      wget
      unzip
      jq
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];
}
