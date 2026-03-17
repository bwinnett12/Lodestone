#### Calibre Server
{ config, pkgs, inputs, ... }:

{

  services.filebrowser = {
    enable = true;

	group = "users";
	openFirewall = true;

	user = "pomona";
 
    settings = {
      port = 2000;      # Using port 2000 as seen in your error
      address = "10.0.1.10"; # Listen on your specific internal IP or "0.0.0.0"
      database = "/var/lib/filebrowser/database.db";
      root = "/storage/Orchid/tmep"; # Directly open to your storage
      log = "stdout";
    };
  };
}