
_: {
  flake.nixosModules = {
	"games" = ./games;
	"grafana" = ./grafana;
	"guacamole" = ./guacamole;
	"jellyfin" = ./jellyfin;
	"localai" = ./localai;
	"plan9" = ./plan9;
	"prometheus" = ./prometheus;
	"rustdesk" = ./rustdesk;
	"suwayomi" = ./suwayomi;
  };
}
