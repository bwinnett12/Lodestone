{ config, pkgs, ... }:
{
  # grafana configuration
  services.grafana = {
    enable = true;
    domain = "grafana.island";
    port = 2117;
    addr = "127.0.0.1";

    settings.security.secret_key = "/var/lib/grafana/secret_key";
  };

  # nginx reverse proxy
  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host ${config.services.grafana.domain};
        '';
    };
  };
}
