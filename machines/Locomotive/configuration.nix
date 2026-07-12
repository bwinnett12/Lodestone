{ config, pkgs, lib, inputs, ... }:
{
  imports =
    [
      # <nixos-hardware/raspberry-pi/4>
    ];

  #services.mailroom = {
  #  enable      = true;
  #  llmUrl      = "http://island.tail4b1127.ts.net:8090";
  #  vaultPath   = "";
  #  libraryRoot = "/storage/Library";
  #  listenAddr  = "0.0.0.0:3000";
  #};

  boot = {
    kernel.sysctl."net.ipv4.ip_forward" = 1;
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    tmp.useTmpfs = true;
  };
  
  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ######## Network settings
  networking = {
    firewall = {
      allowedTCPPorts = [ 
        80 
        53 
        5900  # 5900 -x11vnc
        1984  # 1984 - go2rtc
        8555  # 8555 - go2rtc
        8554  # 8554 - go2rtc
      ];
      allowedUDPPorts = [ 
        53 41641 
        5900  # 5900 -x11vnc
        1984  # 1984 - go2rtc
      ];
      trustedInterfaces = [ "tailscale0"  "eth0" ];
    };

    hostName = "Locomotive";
    interfaces.eth0.useDHCP = true;
    nat = {
      enable = true;
      internalInterfaces = [ "eth0" ];
      externalInterface = "wlan0"; # or wherever the Pi gets its internet
    };
  };

  environment.shellAliases = {
    wake-island = "wakeonlan 70:85:c2:50:d2:0a";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = { 
    groups.media = {
      gid = 995; # Pick a unique ID or let NixOS auto-assign
    };
  };

  #services.xserver.displayManager.lightdm.extraConfig = ''
  #  # Forces a fake layout even if nothing is plugged in
  #  xserver-command=X -nocursor
  #'';

  console.enable = false;
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
	  podman
  ];
}
