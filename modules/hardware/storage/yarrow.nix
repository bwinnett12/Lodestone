### Name: Yarrow
### Storage: 10TB
### Type: Western Digital Red
### UUID: 6EFF-B51B
### ./modules/hardware/storage/orchid.nix


{ config, pkgs, lib, ... }:

{
  fileSystems."/storage/Yarrow" = {

	### UUID
    device = "UUID=6EFF-B51B";
    
    fsType = "exfat";
    
    options = [
      "defaults"
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"

      ## Todo - Set permissions on drive
      "uid=suwayomi"
      "gid=suwayomi"
      "umask=0002"
    ];
  };
}