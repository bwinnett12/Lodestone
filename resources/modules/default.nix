# resources/modules/default.nix
{ lib, ... }:
{
  flake.nixosModules = lib.mapAttrs
    (name: _: import ./${name})
    (lib.filterAttrs
      (name: type: type == "directory" && name != "common")
      (builtins.readDir ./.));
}