# resources/citizens/humans.nix
{ config, lib, pkgs, lodestoneRoot, ... }:
with lib;
let
  peopleDir = lodestoneRoot + "/configurations/citizens/users";
  names = builtins.attrNames
    (lib.filterAttrs (n: t: t == "directory") (builtins.readDir peopleDir));

  cfg = config.ecosystem.users;
  userOpts = types.submodule {
    options = {
      enable = mkEnableOption "this user account on this machine";
      description = mkOption { type = types.str; default = ""; };
      shell = mkOption { type = types.package; default = pkgs.bash; };
      extraGroups = mkOption { type = types.listOf types.str; default = []; };
      homeManagerModule = mkOption {
        type = types.path;
        description = "Path to this user's HM entry module";
      };
    };
  };
in {
  imports = map (n: peopleDir + "/${n}/system.nix") names;

  options.ecosystem.users = mkOption {
    type = types.attrsOf userOpts;
    default = {};
  };

  config = {
    users.users = mapAttrs (name: u: mkIf u.enable {
      isNormalUser = true;
      inherit (u) description shell;
      extraGroups = u.extraGroups;
    }) cfg;

    home-manager.users = mapAttrs
      (name: u: mkIf u.enable (import u.homeManagerModule))
      cfg;
  };
}