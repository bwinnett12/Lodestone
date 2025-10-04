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
      "uid=1000"
      "gid=100"
    ];

    # Optional: If you need to ensure a specific user/group owns the files at the root
    # needed for some NTFS/exFAT drives, but often good practice:
    # user = "tarobutter";
    # group = "users";
  };
}