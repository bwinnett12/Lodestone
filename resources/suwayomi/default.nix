## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
##### Suwayomi server
###  

{ config, pkgs, inputs, ... }:

{
  services.suwayomi-server = {
    enable = true;
    user = "tarobutter";
    group = "users";

    dataDir = "/storage/Orchid/Shortstack/suwayomi-server"; 
    openFirewall = true;

    settings = {
      server.port = 2108;
      server.address = "Island";
      server.enableSystemTray = true;
      server.autoDownloadNewChapters = true;
      server.downloadsPath = "/storage/Orchid/Media/Manga";
      server.backupPath = "/storage/Nettle/backups/suwayomi";
      server.debugLogsEnable = true;
  };
 };

  environment.systemPackages = with pkgs; [
    suwayomi-server
  ];

}