## resources/modules/monitoring/grafana.nix

{ config, lib, pkgs, ... }:
let
  # Grafana.com dashboard 1860 = "Node Exporter Full" — the de facto standard,
  # covers CPU, mem, disk, net, thermal, etc. out of the box.
  nodeExporterFullDashboard = pkgs.fetchurl {
    url = "https://grafana.com/api/dashboards/1860/revisions/37/download";
    sha256 = "sha256-0qza4j8lywrj08bqbww52dgh2p2b9rkhq5p313g72i57lrlkacfl"; # nix run nixpkgs#nix-prefetch-url <url>
  };

  dashboardDir = pkgs.linkFarm "grafana-dashboards" [
    { name = "node-exporter-full.json"; path = nodeExporterFullDashboard; }
  ];
in
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
          options.path = dashboardDir;
        }
      ];
    };
  };

  # Module owns its vhost, per your pattern
  services.nginx.virtualHosts."grafana.platatoo.com" = {
    locations."/".proxyPass = "http://127.0.0.1:3000";
  };
}