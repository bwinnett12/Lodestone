

  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ## Local AI by docker-compose



#  systemd.services.localai-docker = {

    ### LocalAI
#    description = "LocalAI via Docker Compose";


    # Wait for network and your storage mount to be ready
    # after = [ "network.target" "docker.service" ];
    
#    requires = [ "docker.service" ];
#    wantedBy = [ "multi-user.target" ];


#    serviceConfig = {
      # Replace the path with wherever you put your docker-compose.yml
#      ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f /etc/localai/docker-compose.yml up"; 
#      ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f /etc/localai/docker-compose.yml down";

      ## Currently using root
      ## #todo - Switch to localai or shortstack user
      ## Currently root

##      User = "localai";
      # Set the working directory to the directory of the compose file
#      WorkingDirectory = "/etc/localai/"; 
###      Restart = "on-failure";
#      RestartSec = "5s";
#  };
#};
