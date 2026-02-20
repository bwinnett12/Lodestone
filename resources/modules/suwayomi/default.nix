## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
##### Suwayomi server
###  

{ config, pkgs, inputs, ... }:

{
  services.suwayomi-server = {

    #TODO - Updated this to be a user named suwayomi
    enable = true;
    user = "tarobutter";
    group = "users";

    dataDir = "/storage/Orchid/shortstack/suwayomi-server"; 
    openFirewall = true;

    settings = {
      server.port = 2108;
      server.address = "Island";
      server.enableSystemTray = true;
      server.autoDownloadNewChapters = true;

      #TODO - Change to Yarrow
      #TODO - give access to yarrow for suwayomi user
      server.downloadsPath = "/storage/Orchid/Media/Manga";
      server.backupPath = "/storage/Nettle/backups/suwayomi";
      server.debugLogsEnable = true;
  };
 };

  environment.systemPackages = with pkgs; [
    suwayomi-server
  ];



}