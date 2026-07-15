# resources/modules/networking/exports.nix
{ ... }: 
{
  flake.ecosystem.networking = import ./default.nix;
}1