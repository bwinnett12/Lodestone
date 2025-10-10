### Name: Orchid
### Storage: 3TB
### Type: 
### UUID: 805F-1092
### ./modules/hardware/storage/orchid.nix


{ config, pkgs, lib, ... }:

{
  fileSystems."/storage/Orchid" = {

	### UUID
    device = "UUID=4074ccad-cc37-4e98-9d6b-9dead0b25e1d";
    
    fsType = "btrfs";
    
    options = [
      "defaults"
      "nofail"
      "x-systemd.automount"
    ];
  };
}