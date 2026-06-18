## Communications profiles
{ config, lib, pkgs, ... }:
let
  cfg = config.profiles.communications;
in {
  options.profiles.communications = {
    enable = lib.mkEnableOption "a Profile for Communications";

    # Professional environment
    professional = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Include Slack, Zoom, etc.";
    };

    ## Gaming environment
    gaming = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include gaming platforms... Discord, Teamspeak";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = 
      lib.optionals cfg.professional [ pkgs.zoom-us pkgs.slack ]
      ++ lib.optionals cfg.gaming [ pkgs.teamspeak_client ]
      ++ [ pkgs.discord ];
  };
}
