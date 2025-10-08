### Name: Orchid
### Storage: 3TB
### Type: 
### UUID: 805F-1092
### ./modules/hardware/storage/orchid.nix


{ config, pkgs, lib, ... }:

{
  fileSystems."/storage/Orchid" = {

	### UUID
    device = "UUID=bc36d5da-5b76-4ef1-9751-c9773c24d08e";
    
    fsType = "btrfs";
    
    options = [
      "defaults"
      "nofail"
      "x-systemd.automount"
    ];
  };
}