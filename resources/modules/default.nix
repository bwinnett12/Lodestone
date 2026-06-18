# resources/modules/default.nix
{
  inputs,
  self,
  lib,
  ...
}: 
_: {
  flake.nixosModules = lib.mapAttrs
    (name: _: ./${name})
    (lib.filterAttrs
      (_: type: type == "directory")
      (builtins.readDir ./.));
}
