
#### Guacamole
{ config, pkgs, inputs, ... }:

{
  ### Guacamole Server
  services.guacamole-server = {
    enable = true;
	
    host = "0.0.0.0";
    port = 4822;
  };

  ### Guacamole Client
  services.guacamole-client = {
    enable = true;
    userMappingXml = ./user-mapping.xml;
    #enableWebserver = true;

    settings = {
      guacd-port = 4822;
      guacd-hostname = "127.0.0.1";
    };
  };

  systemd.sockets.guacamole-server.enable = false;


      ### XRDP Service
  services.xrdp = {
    enable = true;  # Enable the XRDP service
    #defaultWindowManager = "startplasma-x11";  # Change this if you're using a different window manager
    openFirewall = true;  # This will allow traffic through the firewall for RDP
  };

	environment.systemPackages = with pkgs; [
		guacamole-client
		guacamole-server
    #freerdp
	];

    services.tomcat = {
      enable = true;
      purifyOnStart = true;
      webapps = [
        pkgs.guacamole-client
      ];
    extraEnvironment = [ "GUACAMOLE_HOME=/etc/guacamole" ];
    };

    environment.etc."guacamole/user-mapping.xml" = {
      source = ./user-mapping.xml;
      mode = "0644";
    };

    environment.etc."guacamole/guacamole.properties" = {
      text = ''
        guacd-hostname = 127.0.0.1
        guacd-port = 4822
      '';
    };

}
