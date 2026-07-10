# resources/modules/homepage/default.nix
#### ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
#### Home page through docker

{ config, pkgs, inputs, ... }:

{
  systemd.services.homepage-docker = {

	# Wait for network and your storage mount to be ready
	description = "Homepage via Docker Compose";
	after = [ "network.target" "docker.service" ];
	
	requires = [ "docker.service" ];
	wantedBy = [ "multi-user.target" ];

	serviceConfig = {
	  # Replace the path with wherever you put your docker-compose.yml

	  ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f /home/tarobutter/Lodestone/resources/modules/homepage/homepage-docker.yml up";
	  ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f /home/tarobutter/Lodestone/resources/modules/homepage/homepage-docker.yml down";

	  ## TODO - Switch to homepage or shortstack user
	  User = "pamona";

	  # Set the working directory to the directory of the compose file
	  WorkingDirectory = "/storage/shortstack/homepage/"; 
	  Restart = "on-failure";
	  RestartSec = "5s";
	};
  };

  # nginx reverse proxy
  services.nginx = {
    enable = true;
    virtualHosts."home.platatoo.com" = {
      listen = [{ addr = "100.83.209.81"; port = 80; }];
      locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
      };
    };
  };
}


