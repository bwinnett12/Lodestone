# resources/modules/calibre-server/calibre-server.nix
#### Calibre Server
{ config, pkgs, lib, inputs, ... }:

{
  services.calibre-server = {
    enable = lib.mkDefault false;
    group = "calibre";
    user = "calibre";
    libraries = [
        #"/storage/"
        "/storage/Tulip/Media/Books"
    ];
    openFirewall = true;
    port = 2111;
  };

}