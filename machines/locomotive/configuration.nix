{ config, pkgs, lib, ... }:
{
  imports =
    [
      # <nixos-hardware/raspberry-pi/4>
      #./hardware-configuration.nix
    ];
  #hardware = {
  #  raspberry-pi."4".apply-overlays-dtmerge.enable = true;
  #  deviceTree = {
  #    enable = true;
  #    filter = "*rpi-4-*.dtb";
  #  };
  #};



  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;
  


  hardware.enableRedistributableFirmware = true;
  #hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;


  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ### System Information

  networking.hostName = "Locomotive";
  time.timeZone = "America/Anchorage";
  i18n.defaultLocale = "en_US.UTF-8";





  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  ######## Network settings
  
  services.openssh.enable = true;

  ### Networking mechanism
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  services.tailscale.enable = true;
  networking.firewall.trustedInterfaces = [ "tailscale0"  "eth0" ];

  # Enable firewall opening DNS and HTTP for Pi-hole if using host networking
  networking.firewall.allowedTCPPorts = [ 80 53 ];
  networking.firewall.allowedUDPPorts = [ 53 41641 ];


  networking.interfaces.eth0.ipv4.addresses = [{
    address = "192.168.100.1"; # The Pi's address on the private link
    prefixLength = 24;
  }];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };



  networking.firewall.extraCommands = ''
    iptables -A FORWARD -i tailscale0 -o eth0 -j ACCEPT
    iptables -A FORWARD -i eth0 -o tailscale0 -m state --state ESTABLISHED,RELATED -j ACCEPT
  '';

  networking.nat = {
    enable = true;
    internalInterfaces = [ "eth0" ];
    externalInterface = "wlan0"; # or wherever the Pi gets its internet
  };

  











  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tarobutter = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
    initialPassword = "666";
  };



  console.enable = false;
  environment.systemPackages = with pkgs; [
    git
    libraspberrypi
    raspberrypi-eeprom
	  podman



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
  # system.stateVersion = "24.11";
}
