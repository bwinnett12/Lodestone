## resources/modules/networking/default.nix
## Common files used by all machines for networking
{ config, lib, pkgs, ... }: {
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
      };
      allowInterfaces = lib.mkDefault [];
    };
    nginx.enable = true;
    openssh.enable = true;
    tailscale = {
      enable = true;
      permitCertUid = "nginx";
    };
    timesyncd = {
      enable = true;
      servers = [ "time.cloudflare.com" "pool.ntp.org" ];
    };
  };
  networking = { 
    enableIPv6 = false;
    firewall = {
      enable = true;
      allowedUDPPorts = [ config.services.tailscale.port ];
      checkReversePath = "loose";
      trustedInterfaces = [ "tailscale0" ];
      interfaces."tailscale0".allowedTCPPorts = [ 80 443 ];
    };

    # interfaces.eth0.wakeOnLan.enable = true;
    nameservers = [ "1.1.1.1" "8.8.8.8" "100.100.100.100" ];
    networkmanager.enable = true;
  };


  systemd.services.nginx = {
    after = [ "tailscaled.service" "network-online.target" ];
    wants = [ "tailscaled.service" "network-online.target" ];
  };

  programs.ssh.extraConfig = ''
    Host github.com
      HostName github.com
      User git
      IdentityFile /home/tarobutter/.ssh/id_ed25519
      IdentitiesOnly yes
  '';

  environment.systemPackages = with pkgs; [ 
    inetutils
    nettools
    openssh
    openssl
    rustscan
    wakeonlan
  ];
}
