{ config, pkgs, ... }:

{
  # Ensure Docker is enabled
  services.docker.enable = true;

  # Pull the Sonarr Docker image
  systemd.services.docker.serviceConfig.ExecStartPre = ''
    docker pull ghcr.io/linuxserver/sonarr:4.0.15.2941-ls289
  '';
}

