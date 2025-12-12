#### Rust desk
## TODO - Fill this out

{ config, pkgs, inputs, ... }:

{
  systemd.services.docker-rustdesk-server = {

    description = "Rust desk server";
    after = ["docker.service"];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.docker-compose}/bin/docker-compose -f ./rustdesk-docker.yml up
      '';
      Restart = "always";
      User = "tarobutter";
    };
  };

  # Dependencies
  environment.systemPackages = with pkgs; [
    curl
    wget
    unzip
    jq
    docker-compose
    rustdesk
    rustdesk-server
  ];
}
