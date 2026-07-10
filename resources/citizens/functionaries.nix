# resources/citizens/functionaries.nix
### Accounts that perform ecosystem tasks — no login shell, no HM profile
{ config, lib, lodestoneRoot, ... }:
with lib;
let
  cfg = config.ecosystem.functionaries;
  functionaryDir = lodestoneRoot + "/configurations/citizens/functionaries";
  names = builtins.attrNames
    (lib.filterAttrs (n: t: t == "directory") (builtins.readDir functionaryDir));

  functionaryOpts = types.submodule {
    options = {
      enable = mkEnableOption "this functionary account on this machine";
      description = mkOption { type = types.str; default = ""; };
      extraGroups = mkOption { type = types.listOf types.str; default = []; };
    };
  };
in {
  imports = map (n: functionaryDir + "/${n}/system.nix") names;

  options.ecosystem.functionaries = mkOption {
    type = types.attrsOf functionaryOpts;
    default = {};
  };

  config = {
    users.users = mapAttrs (name: f: mkIf f.enable {
      isSystemUser = true;
      group = name;
      description = f.description;
      extraGroups = f.extraGroups;
      home = "/var/lib/${name}";
      createHome = true;
    }) cfg;

    users.groups = mapAttrs (name: f: mkIf f.enable {}) cfg;
  };
}