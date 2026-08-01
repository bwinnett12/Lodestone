# resources/modules/storage/exports.nix
{ ... }:
{
  flake.ecosystem.storage = {
    drives = import ./mount-drives.nix;
    u9fs   = import ./plan9;
  };
}