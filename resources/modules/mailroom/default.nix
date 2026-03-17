{ config, pkgs, ... }:

let
  # This tells Nix to grab the local index.html and put it in the store
  uiFiles = pkgs.stdenv.mkDerivation {
    name = "message-center-ui";
    src = ./.; # Looks in the current directory
    installPhase = ''
      mkdir -p $out
      cp index.html $out/
    '';
  };
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