#### Grafana
# resources/modules/grafana/default.nix
{ config, pkgs, inputs, ... }:
{
  # grafana configuration
  services.grafana = {
    enable = true;
  
    settings.server = {
      http_addr = "127.0.0.1";
      http_port = 2117;
      domain = "grafana.platatoo.com";
    };

    settings.security.secret_key = "/var/lib/grafana/secret_key";
  };

  # nginx reverse proxy
  services.nginx = {
    enable = true;
    virtualHosts.${config.services.grafana.settings.server.domain} = {
      listen = [{ addr = "100.106.125.87"; port = 80; }];  # Tailscale only
      locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
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
