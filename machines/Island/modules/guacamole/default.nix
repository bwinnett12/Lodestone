
#### Guacamole
{ config, pkgs, inputs, ... }:


{
  ### Guacamole Server
  services.guacamole-server = {
    enable = true;
	
    host = "127.0.0.2";
    userMappingXml = ./user-mapping.xml;

  };


  ### Guacamole Client
  services.guacamole-client = {
    enable = true;
    enableWebserver = true;

    settings = {
      guacd-port = 4822;
      guacd-hostname = "127.0.0.2";
    };

  };

	environment.systemPackages = with pkgs; [
		guacamole-client
		guacamole-server
	];
}
