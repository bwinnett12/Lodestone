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
    };

    nameservers = [ "1.1.1.1" "8.8.8.8" "100.100.100.100" ];
    networkmanager.enable = true;
  };

  # Any nginx vhost bound to a literal Tailscale IP races tailscaled on boot:
  # nginx can start before the address is actually assigned, fails with
  # EADDRNOTAVAIL, and burns through its restart budget before Tailscale
  # finishes its handshake. Make nginx wait for tailscaled, and give it
  # enough retries to survive that delay instead of crash-looping to death.
  systemd.services.nginx = {
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
    serviceConfig = {
      Restart = lib.mkForce "on-failure";
      RestartSec = lib.mkForce "5s";
    };
    startLimitIntervalSec = lib.mkForce 120;
    startLimitBurst = lib.mkForce 20;
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
    dnsutils
  ];
}
