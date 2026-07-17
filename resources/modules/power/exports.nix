# resources/modules/power/exports.nix
{ ... }: {
  flake.ecosystem.power = import ./default.nix;
}