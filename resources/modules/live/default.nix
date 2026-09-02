# resources/modules/live/default.nix
# Deploys the camera dashboard HTML as a managed file
{ config, pkgs, lib, ... }:

let
  dashboardHTML = builtins.readFile ./camera-dashboard.html;
  htmlFile = pkgs.writeText "camera-dashboard.html" dashboardHTML;

in
{
  # Firewall rule for this module
  networking.firewall.allowedTCPPorts = [ 8075 ];

  services.nginx.virtualHosts."_" = {
    listen = [ { addr = "0.0.0.0"; port = 8075; } ];
    
    locations."/" = {
      alias = "${htmlFile}";
      extraConfig = ''
        types { text/html html; }
        default_type text/html;
      '';
    };

    locations."~/^/locomotive/(?<stream>.*)$" = {
      proxyPass = "http://127.0.0.1:8554/$stream";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Connection "upgrade";
      '';
    };

    locations."~/^/loom/(?<stream>.*)$" = {
      proxyPass = "http://loom.tail4b1127.ts.net:8554/$stream";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Connection "upgrade";
      '';
    };

    locations."/dashboard" = {
      proxyPass = "http://127.0.0.1:1984/";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host "127.0.0.1:1984";
      '';
    };

    extraConfig = ''
      access_log /var/log/nginx/live_platatoo_access.log;
      error_log /var/log/nginx/live_platatoo_error.log;
    '';
  };
}