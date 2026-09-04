# resources/modules/go2rtc/default.nix
#### WebRTC
{ config, pkgs, inputs, ... }:

{
  services.go2rtc = {
    enable = true;

    package = pkgs.go2rtc;

    settings = {
      api.listen = ":1984"; # The local control dashboard web port
      api.cors = "*";

      streams = {
        locomotive_stream = [
          # Track 1: The Webcam video stream handled cleanly
          "ffmpeg:device?video=/dev/video0#video=h264"
          
          # Track 2: Use the native go2rtc ALSA hook to pull the USB mic directly
          # This automatically crawls the system for the Snowball and transcodes it to Opus
          "alsa:default#audio=opus"
        ];
      };
    };
  };

# Ensures the go2rtc background system worker has direct hardware rights
  users.users.go2rtc = {
    group = "go2rtc";
    extraGroups = [ "video" "audio" "input" "sound"];
    isSystemUser = true;
  };
  users.groups.go2rtc = {};

  systemd.services.go2rtc.serviceConfig = {
    SupplementaryGroups = [ "video" "audio" "input" ];
  };

#        1984  # 1984 - go2rtc
#        8555  # 8555 - go2rtc
#        8554  # 8554 - go2rtc

  environment.systemPackages = with pkgs; [
    alsa-utils  # Installs amixer, arecord, and alsamixer for hardware troubleshooting
  ];
}

