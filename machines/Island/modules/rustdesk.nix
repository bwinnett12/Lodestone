#### Rust desk

{ config, pkgs, inputs, ... }:

{

  #services. = {
  #  enable = true;
  #  openFirewall = true;
    # signal.relayHosts = ["example.com"];
  #};

  environment.systemPackages = with pkgs; [
    curl
    wget
    unzip
    jq
    docker-compose
    rustdesk
    rustdesk-server
  ];

  # Define a systemd service to run docker-compose
  systemd.services.docker-rustdesk-server = {

    description = "Rust desk server";
    after = ["docker.service"];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = ''
        docker-compose -f ./rustdesk-docker.yml up
      '';
      Restart = "always";
      User = "tarobutter";
    };

    StandardOutput = "append:/storage/Orchid/docker-rustdesk-server.out";
    StandardError = "append:/storage/Orchid/docker-rustdesk-server.log";
  };



}
