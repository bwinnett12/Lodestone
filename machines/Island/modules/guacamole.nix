#### Guacamole
{ config, pkgs, inputs, ... }:

{
  ### Guacamole Server
  services.guacamole-server = {
    enable = true;
	
    host = "127.0.0.1";
    userMappingXml = ./guacamole/user-mapping.xml;

     packages = with pkgs; [
		guacamole-server
	 ];
  };


  ### Guacamole Client
  services.guacamole-client = {
    enable = true;
    enableWebserver = true;

    settings = {
      guacd-port = 4822;
      guacd-hostname = "127.0.0.1";
    };

	packages = with pkgs; [
		guacamole-client
	 ];
  };
}
