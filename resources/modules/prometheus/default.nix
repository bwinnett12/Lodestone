#### ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
#### Prometheus module through docker

{ config, pkgs, inputs, ... }:

{
  systemd.services.prometheus = {

	### Prometheus
	description = "Prometheus via Docker Compose";

	# Wait for network and your storage mount to be ready
	after = [ "network.target" "docker.service" ];

	requires = [ "docker.service" ];
	wantedBy = [ "multi-user.target" ];

  serviceConfig = {
    ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f /home/tarobutter/Lodestone/resources/modules/prometheus/prometheus-docker.yml up";
	ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f /home/tarobutter/Lodestone/resources/modules/prometheus/prometheus-docker.yml down";

	## TODO - Switch to localai or shortstack user
	User = "root";
	# Set the working directory to the directory of the compose file
	WorkingDirectory = "/storage/Orchid/shortstack/prometheus/"; 
	Restart = "on-failure";
	RestartSec = "5s";
  };

};
	# Define a user account. Don't forget to set a password with ‘passwd’
users.users.prometheus = {
	isNormalUser = true;
	extraGroups = [ "wheel" "docker" ];
	packages = with pkgs; [
		prometheus
		tree
	];
  };
      
}


