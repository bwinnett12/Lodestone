# resources/modules/live/default.nix
# Deploys the camera dashboard HTML as a managed file
{ config, pkgs, lib, ... }:

let
  # HTML content inline (or could be imported from a separate file)
  dashboardHTML = import "./camera-dashboard.html";

in
{
  # Serve camera dashboard at live.platatoo.com
  services.nginx.virtualHosts."live.platatoo.com" = {
    listen = [
      { addr = "0.0.0.0"; port = 80; }
    ];

    # Create HTML file inline
    locations."/" = {
      return = "200 '${dashboardHTML}'";
      extraConfig = ''
        default_type text/html;
      '';
    };

    # Proxy streams from Locomotive (local)
    locations."~/^/locomotive/(?<stream>.*)$" = {
      proxyPass = "http://127.0.0.1:8554/$stream";
      proxyWebsockets = true;
      proxySetHeaders.Connection = "upgrade";
    };

    # Proxy streams from Loom (remote via Tailscale)
    locations."~/^/loom/(?<stream>.*)$" = {
      proxyPass = "http://loom.tail4b1127.ts.net:8554/$stream";
      proxyWebsockets = true;
      proxySetHeaders.Connection = "upgrade";
    };

    # Convenience: /dashboard redirects to go2rtc
    locations."/dashboard" = {
      proxyPass = "http://127.0.0.1:1984/";
      proxyWebsockets = true;
    };

    accessLog = "/var/log/nginx/live_platatoo_access.log";
    errorLog = "/var/log/nginx/live_platatoo_error.log";
  };

  # Alternative: Serve at platatoo.com/live
  # Uncomment in machines/Locomotive/configuration.nix if you have a main platatoo.com vhost:
  /*
  services.nginx.virtualHosts."platatoo.com".locations."/live/" = {
    return = "200 '${dashboardHTML}'";
    extraConfig = ''
      default_type text/html;
    '';
  };
  */
}
