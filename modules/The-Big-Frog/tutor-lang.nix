# /etc/nixos/modules/tutor-lang.nix
{ config, pkgs, ... }:

{
  # Configure the Tutor service
  services.tutor-lang.enable = true;
  services.tutor-lang.modelServerUrl = "http://127.0.0.1:8080";
  services.tutor-lang.listenAddr = "127.0.0.1";
  services.tutor-lang.listenPort = 8081;
  services.tutor-lang.requestTimeoutSec = 60;
}