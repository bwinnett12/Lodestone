# resources/modules/storage/exports.nix
{ ... }: 
{
  flake.ecosystem.storage.internal = import ./internal-storage.nix;
  flake.ecosystem.storage.external = import ./external-storage.nix;
}