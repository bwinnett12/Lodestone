### Name: Orchid
### Storage: 3TB
### Type: 
### UUID: 4074ccad-cc37-4e98-9d6b-9dead0b25e1d
### ./modules/hardware/storage/orchid.nix


{ config, pkgs, lib, ... }:

{
  ### Permissions - Add "storage-orchid" as a group for access
  users.groups.storage-orchid = { };


  fileSystems."/storage/Orchid" = {

    device = "UUID=4074ccad-cc37-4e98-9d6b-9dead0b25e1d";
    fsType = "btrfs";
    options = [
      "nofail"
      "x-systemd.automount"
      "noatime"
    ];

    owner = "root";
    group = "storage-orchid";
    mode = "0775";
  };
}


