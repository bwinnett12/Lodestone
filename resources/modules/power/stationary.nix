# resources/modules/power/stationary.nix
{ config, lib, pkgs, ... }:
let
  cfg = config.ecosystem.power;
in {
  config = lib.mkIf cfg.stationary.enable {
    services.auto-cpufreq.enable = lib.mkForce false;  # no charger-state switching needed
    powerManagement.cpuFreqGovernor = "performance";
    # no udev battery/GPU-suspend rules — machine is never on battery
  };
}