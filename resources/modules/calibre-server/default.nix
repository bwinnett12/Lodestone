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


  services.calibre-web = {
    enable = true;
    listen.address = "0.0.0.0";
    listen.port = 8083;
    options = {
      calibreLibrary = "/storage/Orchid/Media/Books";
      enableBookUploading = true;
      enableBookConversion = true;
    };
  };

	
  users.users.pomona = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    packages = with pkgs; [
      tree
    ];
};

}
