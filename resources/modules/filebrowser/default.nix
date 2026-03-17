#### Calibre Server
{ config, pkgs, inputs, ... }:

{

  services.filebrowser = {
    enable = true;
    group = "users";
	openFirewall = true;

	user = "pomona";

    address = "0.0.0.0";
	settings = {
      port = 2000;

	};

  };

}
