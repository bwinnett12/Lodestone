# resources/citizens/upgraded.nix
{ config, lib, ... }:
{
  # The full set of elevated/optional groups a machine *might* have.
  # Expands to only the ones that actually exist on this machine.
  ecosystem.upgradedGroups =
    lib.optional (config.users.groups ? surface-control) "surface-control"
    ++ lib.optional (config.users.groups ? anki) "anki"
    ++ lib.optional (config.users.groups ? docker) "docker"
    ++ lib.optional (config.users.groups ? localai) "localai"
    ++ lib.optional (config.users.groups ? gitea) "gitea"
    ++ lib.optional (config.users.groups ? prometheus) "prometheus";
  # add new elevated groups here as new services/hardware modules introduce them —
  # this is the one place that ever needs editing when a new optional group appears
}