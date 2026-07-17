


#### Gitea
# resources/modules/gitea/default.nix
{ config, pkgs, inputs, ... }:
{

  services = {
	# Postgres for tracking
	postgresql = {
	  enable = true;
	  ensureDatabases = [ "gitea" ];
	  ensureUsers = [
		{ name = "gitea"; ensureDBOwnership = true; }
		{ name = "tarobutter"; }
	  ];
	};

  	# Gitea configuration
	gitea = {
	  enable = true;
	  database = {
		type = "postgres";
		name = "gitea";
		user = "gitea";
		socket = "/run/postgresql";
	  };
	  settings.server = {
		HTTP_ADDR = "127.0.0.1";
		HTTP_PORT = 3030;
        DOMAIN = "git.platatoo.com";
		ROOT_URL = "http://git.platatoo.com/";
	  };
	};
	
	## Open on 3030
    nginx = {
	  enable = true;
	  virtualHosts.${config.services.gitea.settings.server.DOMAIN} = {
	    listen = [{ addr = "100.83.209.81"; port = 80; }];  # Tailscale only
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.gitea.settings.server.HTTP_PORT}";
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
  };
}
