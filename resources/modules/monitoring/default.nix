# resources/modules/power/default.nix
{ ... }: {
  imports = [
    ./grafana.nix
    ./prometheus.nix
    # ./cosmic-ppd-shim.nix
    # ./tablet.nix
  ];
}