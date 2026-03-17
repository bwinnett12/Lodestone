{ config, pkgs, ... }:

let
  # This reads the content of your local index.html and writes it to a directory in the Nix store
  uiFiles = pkgs.writeTextDir "index.html" (builtins.readFile ./index.html);
in
{
  services.nginx = {
    enable = true;
    virtualHosts."messages.local" = {
	  listen = [{ addr = "0.0.0.0"; port = 2112; }];
      root = "${uiFiles}";
      locations."/".index = "index.html";
    };
  };
}