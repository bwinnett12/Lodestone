
_: {
  flake.nixosModules = {
	"games" = ./games;
	"guacamole" = ./guacamole;
	"jellyfin" = ./jellyfin;
	"localai" = ./localai;
	"rustdesk" = ./rustdesk;
	"suwayomi" = ./suwayomi;
  };
}
