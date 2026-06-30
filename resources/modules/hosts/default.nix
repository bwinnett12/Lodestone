# resources/modules/hosts/default.nix
{ ... }:
{
  networking.extraHosts = ''
    # Island services
    100.82.185.26  gitea.platatoo.com
    100.82.185.26  app.platatoo.com
    100.82.185.26  grafana.platatoo.com
    100.82.185.26  jellyfin.platatoo.com

    # Machines
    100.82.185.26  island.platatoo.com
    100.81.148.49  loom.platatoo.com
	  100.106.125.87  locomotive.platatoo.com
  '';
}