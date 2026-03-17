#### Calibre Server
{ config, pkgs, inputs, ... }:

{

  services.filebrowser = {
    enable = true;
    group = "users";
	openFirewall = true;

	user = "pomona";

    listen = {
      ip = "0.0.0.0";
	  port = 2000;
	};
  };

}
