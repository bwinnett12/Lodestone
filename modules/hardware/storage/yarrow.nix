### Name: Yarrow
### Storage: 10TB
### Type: Western Digital Red
### UUID: 6EFF-B51B
### ./modules/hardware/storage/yarrow.nix


{ config, pkgs, lib, ... }:

{

  users.groups.storage-yarrow = { };

  fileSystems."/storage/Yarrow" = {

	  ### UUID
    device = "UUID=6EFF-B51B";
    
    fsType = "exfat";
    
    options = [
      "defaults"
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
      "uid=1000"
      "gid=storage-yarrow"
    ];
  };
}