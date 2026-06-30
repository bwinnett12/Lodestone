# resources/modules/hosts/default.nix
{ ... }:
{
  networking.extraHosts = ''
    # Island services - Off temporarily. Now on Loom
    # 100.82.185.26  gitea.platatoo.com
    # 100.82.185.26  app.platatoo.com
    # 100.82.185.26  grafana.platatoo.com
    # 100.82.185.26  jellyfin.platatoo.com

    # Loom services - Off temporarily. Now on Loom
    100.83.209.81  gitea.platatoo.com
    100.83.209.81  app.platatoo.com
    100.83.209.81  grafana.platatoo.com
    100.83.209.81  jellyfin.platatoo.com
    100.83.209.81  anki.platatoo.com

    # Machines
    100.82.185.26  island.platatoo.com
    100.81.148.49  loom.platatoo.com
	  100.106.125.87  locomotive.platatoo.com
  '';
}