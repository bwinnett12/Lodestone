#### Calibre Server
{ config, pkgs, inputs, ... }:

{
  services.calibre-server = {
    enable = true;
	group = "users";
	user = "pomona";
	libraries = [
      "/storage/Orchid/Media/Books"
	];
	openFirewall = true;
	port = 2111;
  };

  environment.systemPackages = with pkgs; [
	pkgs.calibre
  ];

  ## Calibre Web client
  services.calibre-web = {

    enable = true;

	listen = {
      ip = "0.0.0.0";
	  port = 8083;
	};

    options = {
      calibreLibrary = "/storage/Orchid/Media/Books";
      enableBookUploading = true;
      enableBookConversion = true;
    };
  };

	
  users.users.pomona = {
    description = "Roman goddess of the Orchard: Maintainer of apps";
    extraGroups = [
      "input"
      "networkmanager"
      "systemd-journal"
      "wheel"
      "docker"
    ];
    isNormalUser = true;
    shell = pkgs.bash;
  };

}
