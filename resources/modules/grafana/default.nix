{ config, pkgs, ... }:
{
  # grafana configuration
  services.grafana = {
    enable = true;
  
    settings.server = {
      http_addr = "127.0.0.1";
      http_port = 2117;
      domain = "grafana.island";
    };

    settings.security.secret_key = "/var/lib/grafana/secret_key";
  };

  # nginx reverse proxy
  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host ${config.services.grafana.settings.server.domain};
        '';
    };
  };
}
