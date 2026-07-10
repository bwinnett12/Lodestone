## resources/modules/common/networking.nix
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

  systemd.services.nginx = {
    after = [ "tailscaled.service" "network-online.target" ];
    wants = [ "tailscaled.service" "network-online.target" ];
  };
}