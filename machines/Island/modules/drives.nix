#### Hard drives
{ config, pkgs, inputs, ... }:

{

  fileSystems."/storage/Yarrow" = {

    device = "UUID=6EFF-B51B";
    fsType = "exfat";
    options = [
      "defaults"
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
      "gid=1000"      ## todo - Currently with "shared group"
      "uid=1000"      # todo - Replace with tarobutter
      "umask=0002"          # Allows group writing
    ];
  };
  

  fileSystems."/storage/Orchid" = {

    device = "UUID=4074ccad-cc37-4e98-9d6b-9dead0b25e1d";
    fsType = "btrfs";
    options = [
      "nofail"
      "x-systemd.automount"
      "noatime"
    ];

  };


  fileSystems."/storage/Nettle" = {

    device = "UUID=10ba586f-c9b7-48ce-a8e5-7f5adbb34ab9";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
      "x-systemd.automount"
    ];
  };



  ## External Drives
  fileSystems."/storage/Lilac" = {

    device = "UUID=7237-9737";
    fsType = "exfat";
    options = [
      "defaults"
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
      "gid=1000"      ## todo - Currently with "shared group"
      "uid=1000"      # todo - Replace with tarobutter
      "umask=0002"          # Allows group writing
    ];
  };
  


  environment.systemPackages = with pkgs; [
    curl
    wget
    unzip
  ];
  

  
}
