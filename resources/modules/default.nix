# resources/modules/default.nix
{ lib, ... }:
let
  entries = builtins.readDir ./.;
  moduleDirs = lib.filterAttrs (name: type: type == "directory") entries;

  # A directory "self-publishes" (opts out of auto-nixosModules) if it contains its own exports.nix
  selfPublishes = name: builtins.pathExists (./. + "/${name}/exports.nix");
  autoDiscovered = lib.filterAttrs (name: _: !(selfPublishes name)) moduleDirs;

in {
  flake.nixosModules = lib.mapAttrs
    (name: _: import ./${name})
    autoDiscovered;
}
