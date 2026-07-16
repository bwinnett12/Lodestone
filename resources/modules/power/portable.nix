# resources/modules/power/portable.nix
{ config, lib, pkgs, ... }:
let
  cfg = config.ecosystem.power.portables;
in {
  options.ecosystem.power.portables = {
    enable = lib.mkEnableOption "A power management profile for portables";
  };

  config = lib.mkIf cfg.enable {

    # Kernel parameters for better power management on i7-8650U # TODO - Add these into Loom specifically if they are CPU dependant
    boot.kernelParams = [
      "intel_pstate=active"
      "i915.enable_psr=1"        # Panel self-refresh — saves display power
      "i915.enable_rc6=1"        # GPU render standby
    ];

    # Keep thermald for thermal safety across all profiles
    services.thermald.enable = true;

    # auto-cpufreq handles governor switching based on charger state
    services.auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
          scaling_min_freq = 400000;
          scaling_max_freq = 1800000; # Cap at 1.8GHz on battery
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };

    # NVIDIA runtime power management — GPU off when idle
    hardware.nvidia = {
      powerManagement.enable = true;
      powerManagement.finegrained = true; # RTD3 — GPU suspends when not in use
    };

    # udev rule to force GPU off on battery plug/unplug events
    services.udev.extraRules = ''
      # Force NVIDIA into suspend on battery
      SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.bash}/bin/bash -c 'echo auto > /sys/bus/pci/devices/0000:02:00.0/power/control'"
      # Allow NVIDIA to wake on charger
      SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.bash}/bin/bash -c 'echo on > /sys/bus/pci/devices/0000:02:00.0/power/control'"
    '';

    # Profile switching scripts available system-wide
    environment.systemPackages = [
      # Charger ON profiles
      (pkgs.writeShellScriptBin "profile-charge" ''
        echo "Charge mode: GPU suspended, max battery charging"
        echo auto > /sys/bus/pci/devices/0000:02:00.0/power/control
        cpupower frequency-set -g powersave
        echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
        echo "Profile: CHARGE active"
      '')

      (pkgs.writeShellScriptBin "profile-performance" ''
        echo "Performance mode: Full power, GPU on"
        echo on > /sys/bus/pci/devices/0000:02:00.0/power/control
        cpupower frequency-set -g performance
        echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo
        # If charger removed, sustain for 45s then drop to balanced
        if [ "$(cat /sys/class/power_supply/AC/online)" = "0" ]; then
          sleep 45 && profile-balanced-performance &
        fi
        echo "Profile: PERFORMANCE active"
      '')

      # Battery profiles
      (pkgs.writeShellScriptBin "profile-barebones" ''
        echo "Barebones: Maximum battery saving"
        echo auto > /sys/bus/pci/devices/0000:02:00.0/power/control
        cpupower frequency-set -g powersave
        echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
        # Dim display to minimum
        brightnessctl set 20%
        echo "Profile: BAREBONES active"
      '')

      (pkgs.writeShellScriptBin "profile-light" ''
        echo "Light mode: Useful work, no GPU, good longevity"
        echo auto > /sys/bus/pci/devices/0000:02:00.0/power/control
        cpupower frequency-set -g powersave
        echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo
        brightnessctl set 50%
        echo "Profile: LIGHT active"
      '')

      (pkgs.writeShellScriptBin "profile-balanced" ''
        echo "Balanced: No GPU, solid performance"
        echo auto > /sys/bus/pci/devices/0000:02:00.0/power/control
        cpupower frequency-set -g schedutil
        echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo
        brightnessctl set 70%
        echo "Profile: BALANCED active"
      '')

      (pkgs.writeShellScriptBin "profile-balanced-performance" ''
        echo "Balanced-Performance: GPU available, higher performance"
        echo on > /sys/bus/pci/devices/0000:02:00.0/power/control
        cpupower frequency-set -g schedutil
        echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo
        brightnessctl set 80%
        echo "Profile: BALANCED-PERFORMANCE active"
      '')

      (pkgs.writeShellScriptBin "profile-performance-battery" ''
        echo "Performance (battery): GPU on, full turbo"
        echo on > /sys/bus/pci/devices/0000:02:00.0/power/control
        cpupower frequency-set -g performance
        echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo
        echo "Profile: PERFORMANCE (battery) active"
      '')

      pkgs.cpupower
      pkgs.brightnessctl
    ];

    # Allow tarobutter to run profile scripts without sudo
    security.sudo.extraRules = [{
      users = [ "tarobutter" ];
      commands = [
        { command = "${pkgs.cpupower}/bin/cpupower"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/profile-*"; options = [ "NOPASSWD" ]; }
      ];
    }];
  };
}