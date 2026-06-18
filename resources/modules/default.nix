# resources/modules/default.nix
_: {
  flake.nixosModules = lib.mapAttrs
    (name: _: ./${name})
    (lib.filterAttrs
      (_: type: type == "directory")
      (builtins.readDir ./.));
}
