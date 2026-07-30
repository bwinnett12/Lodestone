# resources/modules/storage/exports.nix
{ ... }: 
{
  flake.ecosystem.storage.internal = import ./internal-storage.nix;
  flake.ecosystem.storage.external = import ./external-storage.nix;
  # flake.ecosystem.strorage.plan9   = import ./plan9 # TODO - DO this
}