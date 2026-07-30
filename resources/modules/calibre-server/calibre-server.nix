# resources/modules/calibre-server/calibre-server.nix
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

}