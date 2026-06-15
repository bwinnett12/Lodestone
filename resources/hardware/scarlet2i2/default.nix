# resources/hardware/scarlett-2i2/default.nix
#
# NixOS module: Scarlett 2i2 HLS audio stream
#
# Streams both channels as separate HLS feeds served via Caddy.
# Segments are written continuously; a systemd timer enforces a 1GB cap.
# Axum (or any other tool) can move segments to /var/lib/scarlett-stream/clips/
# to preserve them before cleanup runs.
#
# Usage:
#   imports = [ self.nixosModules."hardware-scarlett-2i2" ];
#   # all defaults are sane, override as needed:
#   services.scarlett-stream.domain = "loom.tail4b1127.ts.net";

{ config, pkgs, lib, ... }:

let
  cfg = config.services.scarlett-stream;

  hlsBase = "/var/lib/scarlett-stream";
  hlsDir  = "${hlsBase}/hls";
  clipDir = "${hlsBase}/clips";

  # One ffmpeg service per channel, parameterised by:
  #   channel    - human label (1 or 2)
  #   mapChannel - HLS output subdirectory and filter label (FL or FR)
  #   outDir     - where to write segments
  mkStreamService = channel: mapChannel: outDir: {
    description = "Scarlett 2i2 HLS stream - Channel ${toString channel}";
    after    = [ "pipewire.service" "pipewire-pulse.service" "sound.target" "network.target" ];
    wants    = [ "pipewire.service" "pipewire-pulse.service" ];
    wantedBy = [ ]; # udev starts these

    environment = {
      PULSE_SERVER = "unix:/run/pulse/native";
      HOME         = hlsBase;
    };

    serviceConfig = {
      User             = "scarlett-stream";
      Group            = "scarlett-stream";
      Restart          = "on-failure";
      RestartSec       = "5s";
      ExecStartPre     = "${pkgs.coreutils}/bin/sleep 3";

      ExecStart = ''
        ${pkgs.ffmpeg}/bin/ffmpeg \
          -hide_banner -loglevel warning \
          -f pulse \
          -i ${lib.escapeShellArg cfg.device} \
          -filter_complex "[0:a]channelsplit=channel_layout=stereo[FL][FR]" \
          -map "[${mapChannel}]" \
          -c:a aac \
          -b:a ${cfg.bitrate} \
          -f hls \
          -hls_time ${toString cfg.segmentSeconds} \
          -hls_list_size 0 \
          -hls_flags append_list \
          -hls_segment_type mpegts \
          -hls_segment_filename "${outDir}/seg-%%06d.ts" \
          "${outDir}/stream.m3u8"
      '';
    };
  };

  # Cleanup script: enforces 1GB cap on hlsDir, preserving clips/
  cleanupScript = pkgs.writeShellScript "scarlett-cleanup" ''
    set -euo pipefail

    HLS_DIR="${hlsDir}"
    CAP_BYTES=$((1 * 1024 * 1024 * 1024))  # 1 GB

    # Sum current usage
    used=$(du -sb "$HLS_DIR" 2>/dev/null | cut -f1 || echo 0)

    if [ "$used" -le "$CAP_BYTES" ]; then
      exit 0
    fi

    echo "scarlett-cleanup: HLS dir at $(( used / 1024 / 1024 ))MB, pruning oldest segments..."

    # Find all .ts segments sorted oldest-first, delete until under cap
    find "$HLS_DIR" -name "seg-*.ts" -printf "%T+ %p\n" \
      | sort \
      | while read -r _timestamp path; do
          used=$(du -sb "$HLS_DIR" 2>/dev/null | cut -f1 || echo 0)
          if [ "$used" -le "$CAP_BYTES" ]; then
            break
          fi
          echo "Deleting: $path"
          rm -f "$path"
        done
  '';

in {

  ## ─── Options ────────────────────────────────────────────────────────────── ##

  options.services.scarlett-stream = {

    enable = lib.mkEnableOption "Scarlett 2i2 HLS audio stream" // { default = true; };

    domain = lib.mkOption {
      type        = lib.types.str;
      default     = "loom.tail4b1127.ts.net";
      description = "Domain Caddy will serve the HLS stream on (should be your Tailscale hostname).";
    };

    device = lib.mkOption {
      type        = lib.types.str;
      default     = "alsa_input.usb-Focusrite_Scarlett_2i2_USB-00.analog-stereo";
      description = ''
        PipeWire/PulseAudio source name for the Scarlett 2i2.
        Find yours with: pactl list sources short
      '';
    };

    bitrate = lib.mkOption {
      type        = lib.types.str;
      default     = "192k";
      description = "Audio bitrate per channel (e.g. 128k, 192k, 320k).";
    };

    segmentSeconds = lib.mkOption {
      type        = lib.types.int;
      default     = 10;
      description = ''
        Duration of each HLS .ts segment in seconds.
        10s = ~240KB per segment at 192k, ~360 segments per GB.
        Shorter = finer clip granularity. Longer = fewer files.
      '';
    };

    cleanupInterval = lib.mkOption {
      type        = lib.types.str;
      default     = "5min";
      description = "How often to run the 1GB cleanup timer (systemd time format).";
    };

    exposeLAN = lib.mkOption {
      type        = lib.types.bool;
      default     = false;
      description = "Also expose the HTTP port on LAN, not just Tailscale.";
    };

  };

  ## ─── Config ─────────────────────────────────────────────────────────────── ##

  config = lib.mkIf cfg.enable {

    # ── PipeWire (system-wide so the service user can access it) ──────────── #
    services.pipewire = {
      enable      = lib.mkDefault true;
      alsa.enable = lib.mkDefault true;
      pulse.enable = lib.mkDefault true;
      systemWide  = true;
    };

    environment.systemPackages = [ pkgs.ffmpeg ];

    # ── Users ─────────────────────────────────────────────────────────────── #
    users.users.scarlett-stream = {
      isSystemUser = true;
      group        = "scarlett-stream";
      extraGroups  = [ "audio" "pipewire" ];
      home         = hlsBase;
      createHome   = true;
      description  = "Scarlett HLS stream service user";
    };
    users.groups.scarlett-stream = {};

    # ── Directory layout ──────────────────────────────────────────────────── #
    systemd.tmpfiles.rules = [
      "d ${hlsBase}      0755 scarlett-stream scarlett-stream -"
      "d ${hlsDir}       0755 scarlett-stream scarlett-stream -"
      "d ${hlsDir}/ch1   0755 scarlett-stream scarlett-stream -"
      "d ${hlsDir}/ch2   0755 scarlett-stream scarlett-stream -"
      "d ${clipDir}      0755 scarlett-stream scarlett-stream -"
    ];

    # ── ffmpeg stream services ─────────────────────────────────────────────── #
    systemd.services.scarlett-stream-ch1 = mkStreamService 1 "FL" "${hlsDir}/ch1";
    systemd.services.scarlett-stream-ch2 = mkStreamService 2 "FR" "${hlsDir}/ch2";

    # ── udev: auto-start on plug-in, stop on unplug ───────────────────────── #
    services.udev.extraRules = ''
      SUBSYSTEM=="sound", ATTRS{idVendor}=="1235", ATTRS{idProduct}=="8210", \
      TAG+="systemd", ENV{SYSTEMD_WANTS}="scarlett-stream-ch1.service scarlett-stream-ch2.service"
    '';

    # ── 1GB rolling cleanup timer ─────────────────────────────────────────── #
    systemd.services.scarlett-cleanup = {
      description = "Scarlett HLS segment cleanup (1GB cap)";
      serviceConfig = {
        Type            = "oneshot";
        User            = "scarlett-stream";
        ExecStart       = cleanupScript;
      };
    };

    systemd.timers.scarlett-cleanup = {
      description = "Run Scarlett HLS cleanup every ${cfg.cleanupInterval}";
      wantedBy    = [ "timers.target" ];
      timerConfig = {
        OnBootSec   = "1min";
        OnUnitActiveSec = cfg.cleanupInterval;
        Unit        = "scarlett-cleanup.service";
      };
    };

    # ── Caddy: serve HLS over HTTPS on Tailscale ──────────────────────────── #
    services.caddy = {
      enable = true;
      virtualHosts.${cfg.domain} = {
        extraConfig = ''
          root * ${hlsBase}
          file_server browse

          # Allow HLS players to request segments cross-origin
          header Access-Control-Allow-Origin "*"
          header Cache-Control "no-cache"
        '';
      };
    };

    # ── Firewall ──────────────────────────────────────────────────────────── #
    # Caddy listens on 80/443; only open to Tailscale unless exposeLAN is set
    networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 80 443 ];
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.exposeLAN [ 80 443 ];

  };
}
