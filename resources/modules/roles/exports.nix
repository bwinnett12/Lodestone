# resources/modules/networking/exports.nix
{ ... }: {
  flake.ecosystem.roles = {
    builder = import ./builder.nix;
  };
}