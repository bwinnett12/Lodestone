# configurations/functionaries/pamona/system.nix
{ config, lib, ... }: {
  ecosystem.functionaries.pamona = {
    enable = true;
    description = "Maintainer of Apps and Roman goddess of Orchards";
    extraGroups = [ "systemd-journal" ] ++
	lib.optional (config.services.localai.enable or false) "localai"
      ++ lib.optional (config.services.gitea.enable or false) "gitea"
      ++ lib.optional (config.services.prometheus.enable or false) "prometheus";
  };
}