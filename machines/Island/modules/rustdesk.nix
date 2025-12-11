#### Rust desk

{ config, pkgs, inputs, ... }:

{

  services.rustdesk-server = {
    enable = true;
    openFirewall = true;
    # signal.relayHosts = ["example.com"];
  };


}
