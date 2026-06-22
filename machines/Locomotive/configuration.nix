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
    tmpOnTmpfs = true;
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
    networkmanager.enable = true;
  };

  environment.shellAliases = {
    wake-island = "wakeonlan 70:85:c2:50:d2:0a";
  };


  #networking.interfaces.eth0.ipv4.addresses = [{
  #  address = "192.168.100.1"; # The Pi's address on the private link
  #  prefixLength = 24;
  #}];


  #networking.firewall.extraCommands = ''
  #  iptables -A FORWARD -i tailscale0 -o eth0 -j ACCEPT
  #  iptables -A FORWARD -i eth0 -o tailscale0 -m state --state ESTABLISHED,RELATED -j ACCEPT
  #'';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = { 
    users.tarobutter = {
      isNormalUser = true;
      extraGroups = [
        "input"
        "networkmanager"
        "systemd-journal"
        "wheel"
        "docker"
        "video"
        "render"
        "jellyfin"
        "storage-Orchid"
        "storage-Yarrow"
        "storage-Tulip"
        "media"
        "rustdesk"
        "uinput"
        "go2rtc"
        ];
      packages = with pkgs; [
        tree
      ];
      initialPassword = "666";
    };
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
    git
    libraspberrypi
    raspberrypi-eeprom
	  podman

    wakeonlan

    vim
    wget

    openssl
    nettools
    rustscan

    coreutils

    exfatprogs
    parted
    btrfs-progs
    lsof
  ];
}
