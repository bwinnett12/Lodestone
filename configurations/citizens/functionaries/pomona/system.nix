# configurations/citizens/functionaries/pomona/system.nix
{ config, lib, ... }: {


  ecosystem.functionaries.pomona = {
    enable = true;
    uid = 1500;
    description = "Maintainer of Apps and Roman goddess of Orchards";
    extraGroups = [ "systemd-journal" ] ++
	       lib.optional (config.services.localai.enable or false) "localai"
      ++ lib.optional (config.services.gitea.enable or false) "gitea"
      ++ lib.optional (config.services.u9fs-server.enable or false
                    || config.services.u9fs-client.enable or false) "u9fs"
      ++ lib.optional (config.services.prometheus.enable or false) "prometheus"
      ++ lib.optional (config.systemd.services.localai-docker.enable or false) "docker";
  };
}