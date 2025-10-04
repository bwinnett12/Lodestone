### Name: Nettle
### Storage: 1TB
### Type: 
### UUID: 10ba586f-c9b7-48ce-a8e5-7f5adbb34ab9
### ./modules/hardware/storage/nettle.nix


{ config, pkgs, lib, ... }:

{
  fileSystems."/storage/Nettle" = {

	### UUID
    device = "UUID=10ba586f-c9b7-48ce-a8e5-7f5adbb34ab9";
    
    fsType = "exfat";
    
    options = [
      "defaults"
      "nofail"
      "x-systemd.automount"
      "uid=1000"
      "gid=100"
    ];

    # Optional: If you need to ensure a specific user/group owns the files at the root
    # needed for some NTFS/exFAT drives, but often good practice:
    #user = "tarobutter";
    # group = "users";
  };
}