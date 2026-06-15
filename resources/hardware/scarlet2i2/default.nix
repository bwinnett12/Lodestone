{ config, pkgs, lib, ... }:
let
  cfg = config.services.scarlett-stream;

  mkService = channel: panExpr: port: {
    description = "Scarlett 2i2 SRT stream - Channel ${toString channel}";
    after = [ "pipewire.service" "pipewire-pulse.service" "sound.target" ];
    wants = [ "pipewire.service" "pipewire-pulse.service" ];

    environment = {
      PULSE_SERVER = "unix:/run/pulse/native";
      HOME = "/var/lib/scarlett-stream";
    };

    serviceConfig = {
      User = "scarlett-stream";
      Restart = "on-failure";
      RestartSec = "5s";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      ExecStart = ''
        ${pkgs.ffmpeg}/bin/ffmpeg \
          -hide_banner -loglevel warning \
          -f pulse -i ${lib.escapeShellArg cfg.device} \
          -filter_complex "[0:a]pan=mono|c0=${panExpr}[out]" \
          -map "[out]" -c:a aac -b:a ${cfg.bitrate} -f adts \
          "srt://0.0.0.0:${toString port}?mode=listener&latency=${toString cfg.latency}"
      '';
    };
  };

in {

  options.services.scarlett-stream = {

    enable = lib.mkEnableOption "Scarlett 2i2 SRT audio stream" // { default = true; };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8888;
      description = "Ch1 port. Ch2 will use port+1 (default: 8889).";
    };

    device = lib.mkOption {
      type = lib.types.str;
      default = "alsa_input.usb-Focusrite_Scarlett_2i2_USB-00.analog-stereo";
      description = ''
        PipeWire/PulseAudio source name for the Scarlett 2i2.
        Find yours with: pactl list sources short
      '';
    };

    bitrate = lib.mkOption {
      type = lib.types.str;
      default = "192k";
      description = "Audio bitrate (e.g. 128k, 192k, 320k).";
    };

    latency = lib.mkOption {
      type = lib.types.int;
      default = 500;
      description = "SRT latency in milliseconds. 500ms is fine for LAN/Tailscale.";
    };

    exposeLAN = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Also expose stream ports on LAN, not just Tailscale.";
    };

  };

  config = lib.mkIf cfg.enable {

    services.pipewire = {
      enable = lib.mkDefault true;
      alsa.enable = lib.mkDefault true;
      pulse.enable = lib.mkDefault true;
      systemWide = true;
    };

    environment.systemPackages = [ pkgs.ffmpeg ];

    # Start both services when Scarlett is plugged in, stop when unplugged
    services.udev.extraRules = ''
      SUBSYSTEM=="sound", ATTRS{idVendor}=="1235", ATTRS{idProduct}=="8210", \
      TAG+="systemd", ENV{SYSTEMD_WANTS}="scarlett-stream-ch1.service scarlett-stream-ch2.service"
    '';

    systemd.services.scarlett-stream-ch1 = mkService 1 "c0=c0" cfg.port;
    systemd.services.scarlett-stream-ch2 = mkService 2 "c0=c1" (cfg.port + 1);

    users.users.scarlett-stream = {
      isSystemUser = true;
      description = "Scarlett SRT stream service user";
      group = "scarlett-stream";
      extraGroups = [ "audio" "pipewire" ];
      home = "/var/lib/scarlett-stream";
      createHome = true;
    };
    users.groups.scarlett-stream = {};

    networking.firewall.interfaces."tailscale0".allowedUDPPorts = [ cfg.port (cfg.port + 1) ];
    networking.firewall.allowedUDPPorts = lib.mkIf cfg.exposeLAN [ cfg.port (cfg.port + 1) ];

  };
}
