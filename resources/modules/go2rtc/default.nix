
#### WebRTC
{ config, pkgs, inputs, ... }:

{


  services.go2rtc = {
    enable = true;

    package = pkgs.go2rtc;
    # Declarative YAML Generation handled directly by the Nix compiler
    settings = {
      api.listen = ":1984"; # The local control dashboard web port
      
      streams = {
        # Defines our live node path using the embedded ffmpeg framework loop
        locomotive_stream = [
          "ffmpeg:device?video=/dev/video0&audio=default"
        ];
      };
    };
  };

  # Grant systemd permissions to interact with hardware device lines
  systemd.services.go2rtc.serviceConfig = {
    SupplementaryGroups = [ "video" "audio" "input" ];
  };

  # Punch holes cleanly through the firewall for monitoring pipelines
  networking.firewall = {
    allowedTCPPorts = [ 1984 8554 8555 ];
    allowedUDPPorts = [ 8555 ]; # WebRTC utilizes high-speed UDP negotiation layers
  };





  environment.systemPackages = with pkgs; [
	  pkgs.go2rtc
  ];


}

