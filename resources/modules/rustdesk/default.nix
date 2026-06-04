{ config, pkgs, ... }:

{
  # Enable RustDesk Signaling Server (hbbs)
  services.rustdesk-server = {
    enable = true;
    signal.enable = true;
    relay.enable = true;
    
    # Optional: If you have a domain name or public IP, put it here.
    # Otherwise, it defaults to your local setup.
    # relay.ip = "your.public.ip.or.domain"; 
  };

  # Data will automatically be stored securely in /var/lib/rustdesk-server
}