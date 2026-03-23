#### ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
#### Home page through docker

{ config, pkgs, inputs, ... }:

{
  systemd.services.anki-docker = {

	### LocalAI
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
  # Define a user account. Don't forget to set a password with ‘passwd’
  #users.users.localai = {
  #	isNormalUser = true;
  #	extraGroups = [ "wheel" "docker" ];
  #	packages = with pkgs; [
  #			tree
  #	];
# };
      
}

