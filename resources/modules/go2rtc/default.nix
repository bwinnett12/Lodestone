
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
          # Track 1: Grab webcam video, explicitly convert pixel output to H.264
          "ffmpeg:device?video=/dev/video0#video=h264"
          
          # Track 2: Use the generalized 'default' system recording pipeline 
          # instead of hardcoding hw:1,0, and encode it on-the-fly to Opus for browsers
          "ffmpeg:device?audio=default#audio=opus"
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
}

