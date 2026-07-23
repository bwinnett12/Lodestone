# resources/modules/calibre-server/default.nix
{ config, pkgs, inputs, ... }:
{
  imports = [
    ./calibre-server.nix
    ./calibre-web.nix
  ];

  # Only create the calibre user/group where calibre-server actually runs
  users = lib.mkIf config.services.calibre-server.enable {
    users.calibre = {
      isSystemUser = true;
      group = "calibre";
      extraGroups = [ "storage" ];
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
