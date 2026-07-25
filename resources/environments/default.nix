# resources/environments/default.nix
## Uses the dendritic pattern (module/{home, system}.nix)
{ lib, ... }:
let
  entries = builtins.readDir ./.;
  environmentDirs = lib.filterAttrs (name: type: type == "directory") entries;
in {
  # Each environment contributes its system.nix as a NixOS module.
  # home.nix is NOT wired here — each environment's own system.nix pulls its
  # sibling home.nix in via home-manager.sharedModules, gated by that
  # environment's own enable option (see neovim/system.nix). This avoids
  # needing a second enable flag in the home-manager module tree.
  flake.ecosystem.environments = lib.mapAttrs
    (name: _: import (./. + "/${name}/system.nix"))
    environmentDirs;
}