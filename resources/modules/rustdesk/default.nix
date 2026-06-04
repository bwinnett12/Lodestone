{ config, pkgs, ... }:

{
  # Enable RustDesk Signaling Server (hbbs)
  services.rustdesk-server = {
    enable = true;
    signal.enable = true;
    relay.enable = true;
    
    # Force hbbs to point to this machine's IP or localhost for the relay
    signal.relayHosts = [ "127.0.0.1" ]; 

    client.enable = true;
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