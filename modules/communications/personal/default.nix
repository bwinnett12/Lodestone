{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.communication-personal;
in {
  options.profiles.communication-personal = {
    enable = lib.mkEnableOption "a Profile for Personal Communications";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.thunderbird
    ];
  };
}