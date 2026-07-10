# configurations/general/default.nix
{ lib, ... }:
let
  entries = builtins.readDir ./.;

  # directories (like development/) — Nix resolves ./development to ./development/default.nix automatically
  profileDirs = builtins.attrNames
    (lib.filterAttrs (name: type: type == "directory") entries);

  # standalone .nix files (like games.nix, communications.nix, sleep.nix) — exclude this file itself
  profileFiles = builtins.attrNames
    (lib.filterAttrs
      (name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix")
      entries);
in {
  imports =
    map (n: ./. + "/${n}") profileDirs
    ++ map (n: ./. + "/${n}") profileFiles;
}