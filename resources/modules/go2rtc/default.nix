
#### WebRTC
{ config, pkgs, inputs, ... }:

{
  services.go2rtc = {
    enable = true;

    package = pkgs.go2rtc;

    settings = {
      api.listen = ":1984"; # The local control dashboard web port

      streams = {
        locomotive_stream = [
          # Force a manual system-level capture that locks the mic and camera together
          "exec:${pkgs.ffmpeg}/bin/ffmpeg -f v4l2 -input_format mjpeg -i /dev/video0 -f alsa -i default -c:v libx264 -preset ultrafast -tune zerolatency -c:a libopus -b:a 128k -f rtsp {output}"
        ];
      };
    };
  };

# Ensures the go2rtc background system worker has direct hardware rights
  users.users.go2rtc = {
    group = "go2rtc";
    extraGroups = [ "video" "audio" "input" ];
    isSystemUser = true;
  };
  users.groups.go2rtc = {};

  systemd.services.go2rtc.serviceConfig = {
    SupplementaryGroups = [ "video" "audio" "input" ];
  };

  environment.systemPackages = with pkgs; [
    alsa-utils  # Installs amixer, arecord, and alsamixer for hardware troubleshooting
  ];
}

