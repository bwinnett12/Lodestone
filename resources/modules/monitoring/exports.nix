# resources/modules/common/exports.nix
{ ... }: {
  flake.ecosystem.monitoring = import ./default.nix;
}