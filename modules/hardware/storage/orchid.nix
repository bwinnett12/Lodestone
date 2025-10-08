### Name: Orchid
### Storage: 3TB
### Type: 
### UUID: 805F-1092
### ./modules/hardware/storage/orchid.nix


{ config, pkgs, lib, ... }:

{
  fileSystems."/storage/Orchid" = {

	### UUID
    device = "UUID=0d360bd2-a774-4d26-91c4-def6d9fd9ce7";
    
    fsType = "btrfs";
    
    options = [
      "defaults"
      "nofail"
      "x-systemd.automount"
    ];
  };
}