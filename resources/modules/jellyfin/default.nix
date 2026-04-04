#### Jellyfin server
{ config, pkgs, inputs, ... }:

{
  # Enable the Jellyfin service
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    
    user = "pomona";  # todo - Provide a better solution for this
    group = "jellyfin";  # todo - Provide a better solution for this

    dataDir = "/storage/Yarrow/temp";  # TODO  - Re-implement with 9p system
    configDir = "/storage/Yarrow/temp5";  # TODO  - Re-implement with 9p system
    logDir = "/storage/Yarrow/temp6";  # TODO - Re-implement with 9p system
    cacheDir = "/storage/Yarrow/temp-cache";
    # webdir = "/storage/Yarrow/temp-web";
    # cacheDir = ""; # todo - Set this to be the SSD?

    serviceConfig = {
      DeviceAllow = [ "/dev/dri/renderD128" ];
    };
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

