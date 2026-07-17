# resources/modules/power/options.nix
{ lib, ... }: {
  options.ecosystem.power = {
    enable       = lib.mkEnableOption "Power management";
    shellAliases = lib.mkEnableOption "Power profile shell aliases";

    portable.enable  = lib.mkEnableOption "Power profile for battery-powered machines (Loom)";
    dependent.enable = lib.mkEnableOption "Power profile for wall-powered/stationary machines (Island)";
    # tablet.enable  = lib.mkEnableOption "Power profile for tablets";  # add when the Tab shows up
  };
}