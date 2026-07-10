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

  programs.ssh.extraConfig = ''
    Host github.com
      HostName github.com
      User git
      IdentityFile /home/tarobutter/.ssh/id_ed25519
      IdentitiesOnly yes
  '';
}