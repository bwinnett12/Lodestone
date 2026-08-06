{ config, lib, pkgs, ... }:
{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
        domain = "grafana.platatoo.com";
        root_url = "http://grafana.platatoo.com/";
      };

      "auth.anonymous" = {
        enabled = true;
        org_role = "Viewer";
      };

      security.secret_key = "$__file{/var/lib/grafana/secrets/secret_key}";
    };

    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          url = "http://127.0.0.1:9090";
          isDefault = true;
        }
      ];
      dashboards.settings.providers = [
        {
          name = "default";
          options.path = ./dashboards;   # committed directory, no fetchurl
        }
      ];
    };
  };
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 3000 ];

    # nginx reverse proxy
  services.nginx = {
    enable = true;
    virtualHosts."grafana.platatoo.com" = {
      listen = [{ addr = "100.83.209.81"; port = 80; }];
      locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
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