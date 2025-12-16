
_: {
  flake.nixosModules = {
	"games" = ./games;
	"guacamole" = ./guacamole;
	"jellyfin" = ./jellyfin;
	"rustdesk" = ./rustdesk;
	"suwayomi" = ./suwayomi;
  };
}
