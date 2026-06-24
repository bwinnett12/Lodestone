#### Jellyfin server
# resources/modules/jellyfin/default.nix
{ config, pkgs, ... }:

{
  ## Setup Jellyfin user
  users = {
    users.jellyfin = {
      isSystemUser = true;
      group = "jellyfin";
      extraGroups = [ "video" "render" ];
      createHome = true;
      home = "/var/lib/jellyfin";
    };
  groups.jellyfin = {};
  };

  # Enable the Jellyfin service
  services.jellyfin = {
    enable = true;
    openFirewall = true;

    dataDir  = "/var/lib/jellyfin";
    configDir = "/var/lib/jellyfin/config";
    logDir   = "/var/log/jellyfin";
    cacheDir = "/storage/Orchid/shortstack/jellyfin/cache";
  };


  systemd = {
    services.jellyfin.serviceConfig = {
      DeviceAllow = [ "/dev/dri/renderD128" "rw" ];
      SupplementaryGroups = [ "video" "render" ];
    };

    tmpfiles.rules = [
      "d /var/lib/jellyfin           0700 jellyfin jellyfin -"
      "d /var/lib/jellyfin/config    0700 jellyfin jellyfin -"
      "d /var/log/jellyfin           0700 jellyfin jellyfin -"
      "d /storage/Orchid/shortstack/jellyfin/cache  0700 jellyfin jellyfin -"
    ];

  };

  ## Nginx
  services.nginx.virtualHosts."jellyfin.${config.networking.hostName}" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:8096";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
  };

  ## Infrastructure
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
