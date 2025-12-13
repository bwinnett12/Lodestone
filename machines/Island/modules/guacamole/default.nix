
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
    #enableWebserver = true;

    settings = {
      guacd-port = 4822;
      guacd-hostname = "Island";
    };

  };

  services.tomcat = {
      enable = true;
      purifyOnStart = true;
      webapps = [
        pkgs.guacamole-client
      ];
    # extraEnvironment = [ "GUACAMOLE_HOME=/etc/guacamole" ];
    };  

	environment.systemPackages = with pkgs; [
		guacamole-client
		guacamole-server
    freerdp
	];
}
