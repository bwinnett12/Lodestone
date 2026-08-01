# resources/modules/networking/exports.nix
{ ... }: {
  flake.ecosystem.networking.common = import ./default.nix;
  flake.ecosystem.networking.hosts  = import ./hosts.nix;

}