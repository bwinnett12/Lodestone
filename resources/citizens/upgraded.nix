# resources/citizens/upgraded.nix
{ config, lib, ... }:
{

  options.ecosystem.upgradedGroups = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "Elevated/optional groups available on this machine, for accounts with `upgraded = true`.";
  };

  # The full set of elevated/optional groups a machine *might* have.
  # Expands to only the ones that actually exist on this machine.
  # TODO - Implement an automatic solution for this
  config.ecosystem.upgradedGroups =
    lib.optional (config.users.groups ? surface-control) "surface-control"
    ++ lib.optional (config.users.groups ? anki) "anki"
    ++ lib.optional (config.users.groups ? docker) "docker"
    ++ lib.optional (config.users.groups ? localai) "localai"
    
    ++ lib.optional (config.users.groups ? gitea) "gitea"
    ++ lib.optional (config.users.groups ? postgres) "postgres"
    ++ lib.optional (config.users.groups ? uinput) "uinput"

    ++ lib.optional (config.users.groups ? docker) "docker"
    ++ lib.optional (config.users.groups ? jellyfin) "jellyfin"
    ++ lib.optional (config.users.groups ? storage-Orchid) "storage-Orchid"
    ++ lib.optional (config.users.groups ? storage-Tulip) "storage-Tulip"
    ++ lib.optional (config.users.groups ? storage-Yarrow) "storage-Yarrow"
    ++ lib.optional (config.users.groups ? media) "media"
    ++ lib.optional (config.users.groups ? go2rtc) "go2rtc"

    ++ lib.optional (config.users.groups ? u9fs) "u9fs"
    ++ lib.optional (config.users.groups ? uinput) "uinput"
    ++ lib.optional (config.users.groups ? rustdesk) "rustdesk"



    
    ++ lib.optional (config.users.groups ? prometheus) "prometheus";
  # add new elevated groups here as new services/hardware modules introduce them —
  # this is the one place that ever needs editing when a new optional group appears
}