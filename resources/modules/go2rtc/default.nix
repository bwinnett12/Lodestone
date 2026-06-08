
#### WebRTC
{ config, pkgs, inputs, ... }:

{


  environment.systemPackages = with pkgs; [
	  pkgs.go2rtc
  ];


}

