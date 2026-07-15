# resources/lib/drives.nix
{ lib, ... }:

let
  exfat = uuid: {
    device = "UUID=${uuid}";
    fsType = "exfat";
    options = [
      "defaults" "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
      "uid=1000" "gid=1000" "umask=0002"
    ];
  };

  ext4 = uuid: {
    device = "UUID=${uuid}";
    fsType = "ext4";
    options = [ "defaults" "nofail" "x-systemd.automount" ];
  };

  btrfs = uuid: {
    device = "UUID=${uuid}";
    fsType = "btrfs";
    options = [ "defaults" "nofail" "x-systemd.automount" ];
  };

in {
  # All known drives in the ecosystem
  known = {
    Yarrow = exfat  "6EFF-B51B";
    Orchid = btrfs  "4074ccad-cc37-4e98-9d6b-9dead0b25e1d";
    Tulip  = exfat  "809C-FB5D";
    Lilac  = exfat  "7237-9737";
    Nettle = ext4   "10ba586f-c9b7-48ce-a8e5-7f5adbb34ab9";
  };
}