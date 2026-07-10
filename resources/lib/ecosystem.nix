# resources/lib/ecosystem.nix
{ lib, ... }: {
  options.flake.ecosystem = lib.mkOption {
    type = lib.types.attrsOf lib.types.raw;
    default = {};
    description = "Custom ecosystem namespace for hand-curated flake exposures (citizens, common, etc).";
  };
}