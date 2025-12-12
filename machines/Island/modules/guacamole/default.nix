
#### Guacamole
{ config, pkgs, inputs, ... }:


{
  ### Guacamole Server
  services.guacamole-server = {
    enable = true;
	
    host = "0.0.0.0";
    userMappingXml = ./user-mapping.xml;

  };


  ### Guacamole Client
  services.guacamole-client = {
    enable = true;
    enableWebserver = true;

    settings = {
      guacd-port = 4822;
      guacd-hostname = "Island";
    };

  };

	environment.systemPackages = with pkgs; [
		guacamole-client
		guacamole-server
    freerdp
	];
}
