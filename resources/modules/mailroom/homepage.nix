# resources/modules/homepage/default.nix
{ config, pkgs, ... }:
{
  services.nginx = {
    enable = true;
    virtualHosts."platatoo.com" = {
      default = true;
      listen = [{ addr = "100.106.125.87"; port = 80; }];
      
      locations."/" = {
        proxyPass = "http://127.0.0.1:8095";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
      
      locations."/mailroom" = {
        proxyPass = "http://127.0.0.1:8095";
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

  environment.systemPackages = with pkgs; [ curl wget unzip nginx ];
}