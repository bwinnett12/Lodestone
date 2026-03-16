#### Gaming Module
{ config, pkgs, inputs, ... }:

{

  services.calibre-server = {
    enable = true;
	group = "root";
	user = "root";
	libraries = [
      "/storage/Orchid/Media/Books"
	];
	openFirewall = true;
	port = "2111";
  };

  environment.systemPackages = with pkgs; [
	pkgs.calibre
  ];


}
