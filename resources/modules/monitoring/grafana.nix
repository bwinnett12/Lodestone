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

  services.nginx.virtualHosts."grafana.platatoo.com" = {
    locations."/".proxyPass = "http://127.0.0.1:3000";
  };
}