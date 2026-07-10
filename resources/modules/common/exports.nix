# resources/modules/common/exports.nix
{ ... }: {
  flake.ecosystem.common = import ./default.nix;
}