# resources/modules/hosts/default.nix
{ ... }:
{
  networking.extraHosts = ''
    # PiHole ran on Locomotive
    100.106.125.87  pihole.platatoo.com
    100.106.125.87  git.platatoo.com
    100.106.125.87  grafana.platatoo.com
    100.106.125.87  mail.platatoo.com
    100.106.125.87  platatoo.com

    # Island services - Off temporarily. Now on Loom
    # 100.82.185.26  app.platatoo.com
    # 100.82.185.26  grafana.platatoo.com
    # 100.82.185.26  jellyfin.platatoo.com

    # Loom services
    100.83.209.81  ai.platatoo.com
    100.83.209.81  jellyfin.platatoo.com
    # 100.83.209.81  anki.platatoo.com
  '';

  dns.hosts = [
    "100.106.125.87 pihole.platatoo.com"
    "100.106.125.87 git.platatoo.com"
    "100.106.125.87 mail.platatoo.com"
    "100.106.125.87 grafana.platatoo.com"
    "100.106.125.87  platatoo.com"

    "100.83.209.81 ai.platatoo.com"
    "100.83.209.81 home.platatoo.com"
    "100.83.209.81 jellyfin.platatoo.com"
  ];
}

