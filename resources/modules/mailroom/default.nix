{ config, pkgs, ... }:

let
  # This reads the content of your local index.html and writes it to a directory in the Nix store
  uiFiles = pkgs.writeTextDir "index.html" (builtins.readFile ./index.html);
in
{
  services.nginx = {
    enable = true;
    virtualHosts."messages.local" = {
      root = "${uiFiles}";
      locations."/".index = "index.html";
    };
  };

  networking.hosts."127.0.0.1" = [ "messages.local" ];
}