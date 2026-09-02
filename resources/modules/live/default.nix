# resources/modules/live/default.nix
# Deploys the camera dashboard HTML as a managed file
{ config, pkgs, lib, ... }:

let
  dashboardHTML = builtins.readFile ./camera-dashboard.html;

in
{
  services.nginx.virtualHosts."_" = {
    listen = [ { addr = "0.0.0.0"; port = 80; } ];

    locations."/" = {
      return = "200 '${dashboardHTML}'";
      extraConfig = ''default_type text/html;'';
    };

    locations."~/^/locomotive/(?<stream>.*)$" = {
      proxyPass = "http://127.0.0.1:8554/$stream";
      proxyWebsockets = true;
      proxySetHeaders.Connection = "upgrade";
    };

    locations."~/^/loom/(?<stream>.*)$" = {
      proxyPass = "http://loom.tail4b1127.ts.net:8554/$stream";
      proxyWebsockets = true;
      proxySetHeaders.Connection = "upgrade";
    };

    locations."/dashboard" = {
      proxyPass = "http://127.0.0.1:1984/";
      proxyWebsockets = true;
      proxySetHeaders.Host = "127.0.0.1:1984";
    };

    extraConfig = ''
      access_log /var/log/nginx/live_platatoo_access.log;
      error_log /var/log/nginx/live_platatoo_error.log;
    '';
  };
}