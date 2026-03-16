## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
##### Suwayomi server
###  

{ config, pkgs, inputs, ... }:

{
  services.suwayomi-server = {

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
      server.backupPath = "/storage/Orchid/backups/suwayomi";
      server.debugLogsEnable = true;
  };
 };

   environment.systemPackages = with pkgs; [
      curl
      wget
      unzip
      suwayomi-server

    ];

    # Define a user account. Don't forget to set a password with ‘passwd’
  users.users.suwayomi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    packages = with pkgs; [
      tree
      suwayomi-server
    ];
};
  

}