# resources/modules/storage/mount-drives.nix
{ lib, pkgs, ... }:

let
  known = import ./drives.nix;

  fsOptions = fsType: mode:
    {
      exfat = [ "uid=1000" "gid=1000" "umask=0002" ];
      ext4  = [ ];
      btrfs = [ "compress=zstd" ];
    }.${fsType}
    ++ [ "defaults" "nofail" ]
    ++ lib.optionals (mode == "hotplug") [ "x-systemd.automount" "x-systemd.device-timeout=5s" ];

  mkFileSystem = drive: {
    device  = "UUID=${drive.uuid}";
    fsType  = drive.fsType;
    options = fsOptions drive.fsType drive.mode;
  };

  # Drives where any member of `storage` group gets access at the mount root
  shared = [ "Hydrangea" /* "Archive" */ ];

  hotplugDrives = lib.filterAttrs (_: d: d.mode == "hotplug") known;

  udevRules = lib.concatStringsSep "\n" (lib.mapAttrsToList (name: drive: ''
    ACTION=="add", ENV{ID_FS_UUID}=="${drive.uuid}", \
      RUN+="${pkgs.systemd}/bin/systemctl start storage-${name}.mount"
    ACTION=="remove", ENV{ID_FS_UUID}=="${drive.uuid}", \
      RUN+="${pkgs.systemd}/bin/systemctl stop storage-${name}.mount"
  '') hotplugDrives);

  mkSharedFixupUnit = name: {
    name = "storage-${name}-perms";
    value = {
      description = "Fix ownership/perms on /storage/${name}";
      after = [ "storage-${name}.mount" ];
      requires = [ "storage-${name}.mount" ];
      wantedBy = [ "storage-${name}.mount" ];
      serviceConfig.Type = "oneshot";
      script = ''
        ${pkgs.coreutils}/bin/chown root:storage /storage/${name}
        ${pkgs.coreutils}/bin/chmod 2775 /storage/${name}
      '';
    };
  };

in {
  users.groups.storage = {};

  services.udev.extraRules = udevRules;

  fileSystems = lib.mapAttrs' (name: drive:
    lib.nameValuePair "/storage/${name}" (mkFileSystem drive)
  ) known;

  systemd.services = lib.listToAttrs (map mkSharedFixupUnit shared);

  users.users.tarobutter.extraGroups = [ "storage" ];
}