{ config, pkgs, lib, ... }:

let
  # Importing the types from the lib
  types = lib.types;
in
{
  options = {
    pullImage = lib.mkOption {  # Use lib.mkOption instead of mkOption
      type = types.str;
      default = "";
      description = "The name of the Docker image to pull.";
    };
  };

  config = {

    # Ensure the Docker image is pulled
    systemd.services.sonarr = {
      description = "Sonarr Service";
      after = [ "docker.service" ];
      wants = [ "docker.service" ];
      serviceConfig = {
        ExecStart = "${pkgs.docker}/bin/docker run --rm --name sonarr ${config.pullImage}";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}

