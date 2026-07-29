# resources/modules/orchard-tools/default.nix
{ pkgs, ... }: {
  exports.orchardTools = pkgs.writers.writePython3Bin "build-ron-from-index"
    {} (builtins.readFile ../../../Orchard/18_shells-scripts/build-ron-from-index.py);
}