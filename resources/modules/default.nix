
_: {
  flake.nixosModules = {
	"games" = ./games;
	"guacamole" = ./guacamole;
	"jellyfin" = ./jellyfin;
	"localai" = ./localai;
	"plan9" = ./plan9;
	"rustdesk" = ./rustdesk;
	"suwayomi" = ./suwayomi;
  };
}
