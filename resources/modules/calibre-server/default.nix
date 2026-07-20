#### Calibre Server
{ config, pkgs, inputs, ... }:

{
  services.calibre-server = {
    enable = true;
    group = "calibre";
    user = "calibre";
    libraries = [
        #"/storage/"
        "/storage/Tulip/Media/Books"
    ];
    openFirewall = true;
    port = 2111;
  };

  environment.systemPackages = with pkgs; [
	  pkgs.calibre
  ];

  ## Calibre Web client
  services.calibre-web = {
    enable = true;

    listen = {
      ip = "0.0.0.0";
      port = 8083;
	  };

    options = {
      calibreLibrary = "/storage/Tulip/Media/Books";
      enableBookUploading = true;
      enableBookConversion = true;
    };
  };

  ## Setup Calibre user and group
  users = {
    users.calibre = {
      isSystemUser = true;
      group = "calibre";
      extraGroups = [
        "storage"
       ];
      createHome = true;
      home = "/var/lib/calibre";
    };
  groups.calibre = {};
  };
}
# {
	
#   users.users.pomona = {
#     description = "Roman goddess of the Orchard and Maintainer of our apps";
#     extraGroups = [
#       "input"
#       "networkmanager"
#       "systemd-journal"
#       "wheel"
#       "docker"
#       "grafana"
#       "storage-Orchid"
#       "storage-Yarrow"
#       "jellyfin"
#       "video"   # Required for hardware-accelerated transcoding
#       "render"  # Required for Intel/AMD quicksync/VA-API
#       "media"
#     ];

#     home = "/var/lib/pomona";
#     createHome = true;

#     isNormalUser = true;
#     shell = pkgs.bash;
#   };
#   users.groups.pomona = {};

# }
