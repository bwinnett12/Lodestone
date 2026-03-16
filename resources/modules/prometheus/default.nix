{ config, pkgs, ... }:
{
  # https://nixos.org/manual/nixos/stable/#module-services-prometheus-exporters
  # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/monitoring/prometheus/exporters.nix
  services.prometheus.exporters.node = {
    enable = true;
    port = 9000;
    # For the list of available collectors, run, depending on your install:
    # - Flake-based: nix run nixpkgs#prometheus-node-exporter -- --help
    # - Classic: nix-shell -p prometheus-node-exporter --run "node_exporter --help"
    enabledCollectors = [
      "ethtool"   
      "softirqs"
      "systemd"
      "tcpstat"
      "wifi"
    ];
    # You can pass extra options to the exporter using `extraFlags`, e.g.
    # to configure collectors or disable those enabled by default.
    # Enabling a collector is also possible using "--collector.[name]",
    # but is otherwise equivalent to using `enabledCollectors` above.
    extraFlags = [ "--collector.ntp.protocol-version=4" "--no-collector.mdadm" ];
  };

  services.prometheus = {
    enable = true;
    port = 9090;
    extraFlags = [ "--web.enable-lifecycle" ];
    scrapeConfigs = [
      {
        job_name = "node-exporter";
        static_configs = [
          {
            # This tells Prometheus to look at your Node Exporter
            targets = [ "127.0.0.1:9000" ]; 
          }
        ];
      }
    ];
  };
}