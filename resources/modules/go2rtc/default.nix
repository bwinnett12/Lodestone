
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
          "ffmpeg:device?video=/dev/video0"  ## The Raw USB Webcam hardware video pipeline          
          "ffmpeg:device?audio=hw:1,0#audio=opus"    # The Independent ALSA hardware microphone recording pipeline 
        ];
      };
    };
  };

  # Grant systemd permissions to interact with hardware device lines
  systemd.services.go2rtc.serviceConfig = {
    SupplementaryGroups = [ "video" "audio" "input" ];
  };
}

