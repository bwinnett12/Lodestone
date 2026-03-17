#### Calibre Server
{ config, pkgs, inputs, ... }:

{

  services.filebrowser = {
    enable = true;
    group = "users";
	openFirewall = true;

	user = "pomona";

	extraArgs = [
      "--port" "2000"
      "--address" "0.0.0.0"
      "--database" "/var/lib/filebrowser/database.db"
    ];

  };

}
