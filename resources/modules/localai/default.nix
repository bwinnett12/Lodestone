# resources/modules/localai/default.nix
#### ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
#### Localai module through docker
{ config, pkgs, inputs, ... }:
{
  systemd.services.localai-docker = {

      ### LocalAI
      description = "LocalAI via Docker Compose";

      # Wait for network and your storage mount to be ready
      after = [ "network.target" "docker.service" "tailscaled.service" ];
      
      requires = [ "docker.service"  "tailscaled.service" ];
      wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      #ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f ./localai-docker.yml up"; 
      #ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f ./localai-docker.yml down";

      ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f /storage/shortstack/localai/configuration/localai-docker.yml up";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f /storage/shortstack/localai/configuration/localai-docker.yml down";

      ## TODO - Switch to configuration user
      User = "pomona";
      # Set the working directory to the directory of the compose file
      WorkingDirectory = "/storage/shortstack/localai/"; 
      Restart = "on-failure";
      RestartSec = "5s";
      };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’
  users.users.localai = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    packages = with pkgs; [ tree ];
  };

  # nginx reverse proxy
  services.nginx = {
    enable = true;
    virtualHosts."ai.platatoo.com" = {
      listen = [{ addr = "100.83.209.81"; port = 80; }];
      locations."/" = {
          proxyPass = "http://127.0.0.1:8090";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_read_timeout 300s;
            proxy_send_timeout 300s;
          '';
      };
    };
  };
}
