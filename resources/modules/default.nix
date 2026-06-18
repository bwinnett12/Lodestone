# resources/modules/default.nix
{ lib, ... }:
{
  flake.nixosModules = lib.mapAttrs
    (name: _: import ./${name})
    (lib.filterAttrs
      (_: type: type == "directory")
      (builtins.readDir ./.));
}