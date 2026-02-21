{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
        enforce_domain = true;
        enable_gzip = true;
        domain = "grafana.platatoo";

        # Alternatively, if you want to serve Grafana from a subpath:
        # domain = "your.domain";
        # root_url = "https://your.domain/grafana/";
        # serve_from_sub_path = true;
      };

      # Prevents Grafana from phoning home
      #analytics.reporting_enabled = false;
    };
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