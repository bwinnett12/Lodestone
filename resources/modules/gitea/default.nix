


#### Gitea
# resources/modules/gitea/default.nix
{ config, pkgs, inputs, ... }:
{
  # Gitea configuration
  services = {
	postgresql = {
	  enable = true;
	  ensureDatabases = [ "gitea" ];
	  ensureUsers = [{
		name = "gitea";
		ensureDBOwnership = true;
  	  }];
	};

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
        DOMAIN = "island.tail4b1127.ts.net";
		ROOT_URL = "http://island.tail4b1127.ts.net/";
	  };
	};
    nginx = {
	  enable = true;
	  virtualHosts.${config.services.gitea.settings.server.DOMAIN} = {
	    listen = [{ addr = "100.82.185.26"; port = 80; }];  # Tailscale only
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
