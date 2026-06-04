{ config, pkgs, ... }:

{
  # Enable RustDesk Signaling Server (hbbs)
  services.rustdesk-server = {
    enable = true;
    signal.enable = true;
    relay.enable = true;
    openFirewall = false;
    
    # Force hbbs to point to this machine's IP or localhost for the relay
    signal.relayHosts = [ 
    
      #"100.82.185.26"
      "127.0.0.1"
      #"island"
     ]; 
  };

  #systemd.services.rustdesk-signal.serviceConfig.WorkingDirectory = "/storage/Orchid/shortstack/rustdesk";
  #systemd.services.rustdesk-link.serviceConfig.WorkingDirectory = "/storage/Orchid/shortstack/rustdesk";
  systemd.services.rustdesk-signal.serviceConfig.WorkingDirectory = pkgs.lib.mkForce "/var/lib/rustdesk";
  systemd.services.rustdesk-relay.serviceConfig.WorkingDirectory = pkgs.lib.mkForce "/var/lib/rustdesk";

  # Completely nuke the broken, non-standard 'rustdesk-link' service that your custom module built
  systemd.services.rustdesk-link.enable = pkgs.lib.mkForce false;
  
  systemd.services.rustdesk-daemon = {
    description = "RustDesk Client Service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "exec";
      ExecStart = "${pkgs.rustdesk-flutter}/bin/rustdesk --service";
      Restart = "always";
      RestartSec = "10";
      User = "root";
    };
  };


  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ]; # Or -gtk / -kde depending on your DE
  };
    
    # Optional: If you have a domain name or public IP, put it here.
    # Otherwise, it defaults to your local setup.
    # relay.ip = "your.public.ip.or.domain"; 

  # Data will automatically be stored securely in /var/lib/rustdesk-server
}