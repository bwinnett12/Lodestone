#### ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
#### Anki via Docker Compose
{ config, pkgs, ... }:

{
  # nginx reverse proxy
  services = {

    anki-sync-server = {
      enable = true;
      baseDirectory = "/storage/shortstack/anki";
      port = "3111";
      users = [
        { username = "anki"; password = "666"; }
      ];
    };
    
    nginx = {
      enable = true;
      virtualHosts."anki.platatoo.com" = {
        listen = [{ addr = "100.106.125.87"; port = 80; }];
        locations."/" = {
            proxyPass = "http://127.0.0.1:3111";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
        };
      };
    };
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 3111 ];

  ## Setup Anki user
  users = {
    users.anki = {
      isSystemUser = true;
      group = "anki";
      extraGroups = [ "docker" "wheel" ];
      createHome = true;
      home = "/var/lib/anki";
    };
    groups.anki = {};
  };

}