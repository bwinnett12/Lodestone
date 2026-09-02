# resources/modules/live/default.nix
# Deploys the camera dashboard HTML as a managed file
{ config, pkgs, lib, ... }:

let
  dashboardHTML = builtins.readFile ./camera-dashboard.html;
  
  # Create an HTML file in the Nix store
  htmlFile = pkgs.writeText "camera-dashboard.html" dashboardHTML;

in
{
  services.nginx.virtualHosts."_" = {
    listen = [ { addr = "0.0.0.0"; port = 80; } ];

    ## Serve the HTML file
    locations."/" = {
      alias = "${htmlFile}";
      extraConfig = ''
        types { text/html html; }
        default_type text/html;
      '';
    };

    ## Proxy streams from Locomotive
    locations."~/^/locomotive/(?<stream>.*)$" = {
      proxyPass = "http://127.0.0.1:8554/$stream";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Connection "upgrade";
      '';
    };

    ## Proxy streams from Loom
    locations."~/^/loom/(?<stream>.*)$" = {
      proxyPass = "http://loom.tail4b1127.ts.net:8554/$stream";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Connection "upgrade";
      '';
    };

    ## Go2rtc dashboard
    locations."/dashboard" = {
      proxyPass = "http://127.0.0.1:1984/";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host "127.0.0.1:1984";
      '';
    };

    ## Logging
    extraConfig = ''
      access_log /var/log/nginx/live_platatoo_access.log;
      error_log /var/log/nginx/live_platatoo_error.log;
    '';
  };
}