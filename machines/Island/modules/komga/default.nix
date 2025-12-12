#### Komga Module
{ config, pkgs, inputs, ... }:

{
  services.komga = {

    enable = true;

    openFirewall = false;

    # Configuration for the internal Komga Spring Boot application
    settings = {
      server.port = 2104;
      address = "0.0.0.0";
    };
  };
}