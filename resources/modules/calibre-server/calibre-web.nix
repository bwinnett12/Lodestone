# resources/modules/calibre-server/calibre-web.nix — deleted, or reduced to just:
{ config, lib, ... }: {
  services.calibre-web = lib.mkDefault {
    enable = false; # only Loom turns this on
    listen.ip = "0.0.0.0";
    listen.port = 8083;
  };

  environment.systemPackages = with pkgs; [
    xournalpp
  ];
}