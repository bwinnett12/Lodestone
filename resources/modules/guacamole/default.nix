#### Guacamole
{ config, pkgs, inputs, ... }:

{
  ### Guacamole Server
  services.guacamole-server = {
    enable = true;
    host = "127.0.0.1";
    port = 4822;
  };

  ### Guacamole Client (web UI)
  services.guacamole-client = {
    enable = true;
    userMappingXml = ./user-mapping.xml;
    
    settings = {
      guacd-port = 4822;
      guacd-hostname = "127.0.0.1";
    };
  };

  ### XRDP Service
  services.xrdp = {
    enable = true;
    openFirewall = true;
  };

  services.nginx = {
    enable = true;
    virtualHosts."_" = {
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
}
