# resources/modules/storage/external-drives.nix
{ lib, pkgs, ... }:

let
  externalDrives = {
    Tulip = { uuid = "809C-FB5D"; fsType = "exfat"; };
    Lilac = { uuid = "7237-9737"; fsType = "exfat"; };
  };

  udevRules = lib.concatStringsSep "\n" (lib.mapAttrsToList (name: drive: ''
    ACTION=="add", ENV{ID_FS_UUID}=="${drive.uuid}", \
      RUN+="${pkgs.systemd}/bin/systemctl start storage-${name}.mount"
    ACTION=="remove", ENV{ID_FS_UUID}=="${drive.uuid}", \
      RUN+="${pkgs.systemd}/bin/systemctl stop storage-${name}.mount"
  '') externalDrives);

in {
  services.udev.extraRules = udevRules;

  fileSystems = lib.mapAttrs' (name: drive:
    lib.nameValuePair "/storage/${name}" {
      device  = "UUID=${drive.uuid}";
      fsType  = drive.fsType;
      options = [
        "defaults" "nofail"
        "x-systemd.automount"
        "x-systemd.device-timeout=5s"
        "uid=1000" "gid=1000" "umask=0002"
      ];
    }
  ) externalDrives;
}