# resources/modules/common/exports.nix
{ ... }: {
  flake.ecosystem.power = {
    portable = import ./portable.nix;
  }; 
}