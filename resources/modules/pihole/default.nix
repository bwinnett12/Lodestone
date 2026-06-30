#### Pi-hole
# resources/modules/pihole/default.nix
{ config, pkgs, inputs, ... }:
{
  # Pi-hole configuration
  services.pihole-ftl = {
    enable = true;

	openFirewallDNS = true;        # so other devices on your network can query it
  	openFirewallWebserver = true;  # for the admin UI

	settings = {
      # See <https://docs.pi-hole.net/ftldns/configfile/>

      # External DNS Servers quad9 and cloudflare
      dns.upstreams = [ "9.9.9.9" "1.1.1.1" ];

      # Optionally resolve local hosts (domain is optional)
      dns.hosts = [ "10.0.1.10 island.lodestone"];
    };

	lists = [    # Lists can be added via URL
	  {
		url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt";
		type = "block";
		enabled = true;
		description = "hagezi blocklist";
	  }
	];
  };

  services.pihole-web = {
	enable = true;
	ports = [ "443s" ];
  };

  # nginx reverse proxy
  services.nginx = {
    enable = true;
    virtualHosts.${config.services.grafana.settings.server.domain} = {
      locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
      };
    };
  };
}


