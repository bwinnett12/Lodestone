# resources/lib/ecosystem.nix
{ lib, ... }: {
  options.flake.ecosystem = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    default = {};
    description = "Custom ecosystem namespace for hand-curated flake exposures (citizens, common, etc).";
  };
}