#### Grafana
# resources/modules/grafana/default.nix
{ config, pkgs, inputs, ... }:
{
  # grafana configuration
  services.grafana = {
    enable = true;
  
    settings.server = {
      http_addr = "10.0.1.10";
      http_port = 2117;
      domain = "grafana.island";
    };

    settings.security.secret_key = "/var/lib/grafana/secret_key";
  };

  # nginx reverse proxy
  services.nginx.virtualHosts.${config.services.grafana.settings.server.domain} = {
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
}
