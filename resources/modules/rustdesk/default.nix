{ config, pkgs, inputs, ... }:

let
  rustdeskComposeFile = pkgs.writeText "rustdesk-docker-compose.yml" ''
    version: '3.8'
    services:
      hbbs:
        container_name: hbbs
        image: rustdesk/rustdesk-server:latest
        command: hbbs
        volumes:
          - /var/lib/rustdesk:/data/root
        networks:
          - rustdesk
        ports:
          - "21115:21115"
          - "21116:21116"
          - "21116:21116/udp"
          - "21118:21118"
        depends_on:
          - hbbr
        restart: unless-stopped

      hbbr:
        container_name: hbbr
        image: rustdesk/rustdesk-server:latest
        command: hbbr
        volumes:
          - /var/lib/rustdesk:/data/root
        networks:
          - rustdesk
        ports:
          - "21117:21117"
          - "21119:21119"
        restart: unless-stopped

    networks:
      rustdesk:
  '';
in
{
  # Enable Docker
  virtualisation.docker.enable = true;
  virtualisation.docker-compose.enable = true;

  systemd.services.rustdesk-server = {
    description = "RustDesk Server";
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      COMPOSE_FILE = rustdeskComposeFile;
    };

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.docker}/bin/docker compose -f ${rustdeskComposeFile} up";
      Restart = "on-failure";
      RestartSec = 10;
      User = "root";  # Docker needs root, or add tarobutter to docker group
      StandardOutput = "journal";
      StandardError = "journal";
    };
  };

  # Create persistent directory for RustDesk data
  systemd.tmpfiles.rules = [
    "d /var/lib/rustdesk 0755 root root -"
  ];

  # Dependencies
  environment.systemPackages = with pkgs; [
    curl
    wget
    unzip
    jq
    docker
    docker-compose
    rustdesk
  ];
}
