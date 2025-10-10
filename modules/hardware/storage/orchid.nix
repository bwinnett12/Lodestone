### Name: Orchid
### Storage: 3TB
### Type: 
### UUID: 805F-1092
### ./modules/hardware/storage/orchid.nix


{ config, pkgs, lib, ... }:

{
  ### Permissions - Add "storage-orchid" as a group for access
  users.groups.storage-orchid = { };

  fileSystems."/storage/Orchid" = {

	### UUID
    device = "UUID=4074ccad-cc37-4e98-9d6b-9dead0b25e1d";
    
    fsType = "btrfs";
    
    options = [
      "nofail"
      "x-systemd.automount"
      "noatime"
    ];
    
    mountPoint.owner = "root";       # Root is the typical owner of the mount point itself
    mountPoint.group = "storage-orchid"; # Set the new group
    mountPoint.mode = "0775";        # Set mode: read/write/execute for owner and group, read/execute for others

    # Note: Btrfs usually uses standard ACLs, but you can set defaults here.
    # extraMountOptions = [ "umask=0002" ]; # If you needed umask (less common for Btrfs)
  };
}
