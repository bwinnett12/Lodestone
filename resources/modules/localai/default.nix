#### ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
#### Localai module through docker

{ config, pkgs, inputs, ... }:

{
      systemd.services.localai-docker = {

            ### LocalAI
            description = "LocalAI via Docker Compose";


            # Wait for network and your storage mount to be ready
            after = [ "network.target" "docker.service" ];
            
            requires = [ "docker.service" ];
            wantedBy = [ "multi-user.target" ];


            serviceConfig = {
                  # Replace the path with wherever you put your docker-compose.yml
                  #ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f ./localai-docker.yml up"; 
                  #ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f ./localai-docker.yml down";

                  ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f /home/tarobutter/Lodestone/resources/modules/localai/localai-docker.yml up";
                  ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f /home/tarobutter/Lodestone/resources/modules/localai/localai-docker.yml down";

                  ## TODO - Switch to localai or shortstack user
                  User = "root";
                  # Set the working directory to the directory of the compose file
                  WorkingDirectory = "/storage/Orchid/shortstack/localai/"; 
                  Restart = "on-failure";
                  RestartSec = "5s";
            };

      };
      # Define a user account. Don't forget to set a password with ‘passwd’
      users.users.localai = {
            isNormalUser = true;
            extraGroups = [ "wheel" "docker" ];
            packages = with pkgs; [
                  tree
            ];
      };
      
}


