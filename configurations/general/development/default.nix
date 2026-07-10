## Development profiles
{ config, lib, pkgs, ... }:
let
  cfg = config.profiles.development;
in {
  options.profiles.development = {
    enable = lib.mkEnableOption "a Profile for Communications";

    # rust
    rust = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Include the rust ecosystem";
    };

    ## julia
    julia = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Include the Julia Ecosystem";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = 
         lib.optionals cfg.rust  [ pkgs.cargo ]
	    ++ lib.optionals cfg.julia [ pkgs.julia ]
      ++                         [ pkgs.alejandra ];
  };
}
