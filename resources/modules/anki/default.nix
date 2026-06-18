#### ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
#### Anki via Docker Compose
{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;

  systemd.services.anki-docker = {
    description = "Anki via Docker Compose";
    after = [ "network.target" "docker.service" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
	  ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f /etc/anki/docker-compose.yml up";
	  ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f /etc/anki/docker-compose.yml down";
      ## TODO - Switch to anki or shortstack user
      User = "root";
      WorkingDirectory = "/storage/Orchid/shortstack/anki";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

  ## Set the docker compose to /var/lib/anki/docker-compose.yml
  environment.etc."anki/docker-compose.yml" = {
	source = ./anki-docker.yml;
	mode = "0644";
  };

  services.nginx.virtualHosts."anki.${config.networking.hostName}" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:3111";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
  };
}