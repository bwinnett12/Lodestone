


#### Front page
# resources/modules/frontpage/default.nix
{ config, pkgs, ... }:
{
    # nginx reverse proxy
  services.nginx = {
	enable = true;
	virtualHosts."platatoo.com" = {
		default = true;   # apex owns the default_server slot explicitly
		listen = [{ addr = "100.83.209.81"; port = 80; }];
		locations."/" = {
		root = pkgs.writeTextDir "index.html" "Coming soon — platatoo.com";
		# or proxyPass to a real frontend once it exists
		};
	};
	};

  ## Infrastructure
  environment.systemPackages = with pkgs; [
    curl
    wget
    unzip
	nginx
  ];
}
