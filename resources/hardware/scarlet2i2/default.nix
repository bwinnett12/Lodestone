{ config, pkgs, lib, ... }:
let
  cfg = config.services.scarlett-stream;
  ffmpeg = "${pkgs.ffmpeg}/bin/ffmpeg";
  device = "alsa_input.usb-Focusrite_Scarlett_2i2_USB-00.analog-stereo";

  srtUrl = port: "srt://0.0.0.0:${toString port}?mode=listener&latency=500";

  ffmpegCmd = ''
    ${ffmpeg} -hide_banner -loglevel warning \
      -f pulse -i ${lib.escapeShellArg device} \
      -filter_complex "[0:a]pan=mono|c0=c0[ch1]; [0:a]pan=mono|c0=c1[ch2]" \
      -map "[ch1]" -c:a aac -b:a 192k -f adts \
        "${srtUrl cfg.port}" \
      -map "[ch2]" -c:a aac -b:a 192k -f adts \
        "${srtUrl (cfg.port + 1)}"
  '';
in {
  options.services.scarlett-stream = {
    enable = lib.mkEnableOption "Scarlett 2i2 SRT audio stream" // { default = true; };
    port = lib.mkOption {
      type = lib.types.port;
      default = 8888;
      description = "Ch1 port. Ch2 will use port+1 (default: 8889).";
    };

    exposeLAN = lib.mkOption {        # ← add here
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

    # Udev: start service when Scarlett is plugged in, stop when unplugged
    services.udev.extraRules = ''
      SUBSYSTEM=="sound", ATTRS{idVendor}=="1235", ATTRS{idProduct}=="8210", \
      TAG+="systemd", ENV{SYSTEMD_WANTS}="scarlett-stream.service"
    '';

    systemd.services.scarlett-stream = {
      description = "Scarlett 2i2 SRT stream (split: ch1=${toString cfg.port}, ch2=${toString (cfg.port + 1)})";
      after = [ "pipewire.service" "pipewire-pulse.service" "sound.target" ];
      wants = [ "pipewire.service" "pipewire-pulse.service" ];
      # NOT in wantedBy — udev triggers it instead

      serviceConfig = {
        User = "scarlett-stream";
        Restart = "on-failure";
        RestartSec = "5s";
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
        ExecStart = ffmpegCmd;
      };

      environment = {
        PULSE_SERVER = "unix:/run/pulse/native";   # system-wide pulse socket
        HOME = "/var/lib/scarlett-stream";
      };

    };

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