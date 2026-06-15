## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
##### Suwayomi server
###  

{ config, pkgs, inputs, ... }:

{
  services.suwayomi-server = {
    enable = true;
    user = "pomona";
    group = "users";

    dataDir = "/storage/Orchid/shortstack/suwayomi-server"; 
    openFirewall = true;

    settings = {
      server.port = 4567;
      server.address = "Island";
      server.enableSystemTray = true;
      server.autoDownloadNewChapters = true;

      #TODO - Change to Yarrow
      #TODO - give access to yarrow for suwayomi user
      server.downloadsPath = "/storage/Orchid/Media/Manga";
      server.backupPath = "/storage/Orchid/backups/suwayomi";
      server.debugLogsEnable = true;
  };
 };

   # TODO - Bake this into the service
   environment.systemPackages = with pkgs; [
      suwayomi-server
    ];
}