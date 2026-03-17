
_: {
  flake.nixosModules = {
	"calibre-server" = ./calibre-server;
	"filebrowser" = ./filebrowser;
	"homepage" = ./homepage;
	"games" = ./games;
	"grafana" = ./grafana;
	"guacamole" = ./guacamole;
	"komga" = ./komga;
	"mailroom" = ./mailroom;
	"jellyfin" = ./jellyfin;
	"localai" = ./localai;
	"plan9" = ./plan9;
	"prometheus" = ./prometheus;
	"rustdesk" = ./rustdesk;
	"suwayomi" = ./suwayomi;
  };
}
