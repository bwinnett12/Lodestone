{ config, pkgs, ... }:
{
  # Enable the Tailscale service
  services.tailscale.enable = true;

  # Tailscale uses a specific interface; ensure the firewall allows it
  networking.firewall.checkReversePath = "loose"; 
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # (Optional) Keep your current Nginx/Grafana blocks here...
}