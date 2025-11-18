{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.communication-professional;
in {
  options.profiles.communication-professional = {
    enable = lib.mkEnableOption "a Profile for Professional Communications";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      #pkgs.slack
      #pkgs.zoom-us
    ];
  };
}