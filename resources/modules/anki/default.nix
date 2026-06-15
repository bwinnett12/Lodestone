#### ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
#### Anki via Docker Compose
{ config, pkgs, inputs, ... }:

{
  systemd.services.anki-docker = {
	description = "Anki via Docker Compose";

	# Wait for network and your storage mount to be ready
	after = [ "network.target" "docker.service" ];
	
	requires = [ "docker.service" ];
	wantedBy = [ "multi-user.target" ];

	serviceConfig = {
	  # Replace the path with wherever you put your docker-compose.yml

	  ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f /home/tarobutter/Lodestone/resources/modules/anki/anki-docker.yml up";
	  ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f /home/tarobutter/Lodestone/resources/modules/anki/anki-docker.yml down";
	
	  ## TODO - Switch to anki or shortstack user
	  User = "root";

	  # Set the working directory to the directory of the compose file
	  WorkingDirectory = "/storage/Orchid/shortstack/anki"; 
	  Restart = "on-failure";
	  RestartSec = "5s";
	};

  };
	virtualisation.docker.enable = true;
}

