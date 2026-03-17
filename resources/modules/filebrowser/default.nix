#### Calibre Server
{ config, pkgs, inputs, ... }:

{

  services.filebrowser = {
    enable = true;
    group = "users";
	openFirewall = true;

	user = "pomona";

    port = 2000;
  };

}
