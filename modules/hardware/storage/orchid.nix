### Name: Orchid
### Storage: 3TB
### Type: 
### UUID: 805F-1092
### ./modules/hardware/storage/orchid.nix


{ config, pkgs, lib, ... }:

{
  fileSystems."/storage/Orchid" = {

	### UUID
    device = "UUID=805F-1092";
    
    fsType = "exfat";
    
    options = [
      "defaults"
      "nofail"
      "x-systemd.automount"
      "uid=1000,9400"
      "gid=100"
    ];

    # Optional: If you need to ensure a specific user/group owns the files at the root
    # needed for some NTFS/exFAT drives, but often good practice:
    # user = "tarobutter";
    # group = "users";
  };
}