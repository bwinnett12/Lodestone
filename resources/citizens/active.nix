# resources/citizens/active.nix
## TODO - Move this to config when things work more
# Single source of truth: canonical UID/GID for every human + functionary across the ecosystem.
{
  humans = {
    tarobutter = { uid = 1000; };
  };
  functionaries = {
    mailroom = { uid = 900; };
    # etc — pull actual values from wherever functionaries.nix currently declares them
  };
  groups = {
    storage = { gid = 1000; };  # matches mount-drives.nix's users.groups.storage.gid = 1000
  };
}