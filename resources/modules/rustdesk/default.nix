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
  systemd.services.rustdesk-link.enable = pkgs.lib.mkForce false;

  # 2. Force the host controller daemon to use the same directory
  systemd.services.rustdesk-daemon.serviceConfig.WorkingDirectory = pkgs.lib.mkForce "/var/lib/rustdesk";

  # 3. Inject the correct explicit environment string options natively
  systemd.services.rustdesk-daemon.environment.RUSTDESK_ID_SERVER = "127.0.0.1";
  systemd.services.rustdesk-daemon.environment.RUSTDESK_RELAY_SERVER = "127.0.0.1";
  
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
      Environment = [ "XDG_RUNTIME_DIR=/run/user/1000" ];
    };
  };


  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };


  environment.systemPackages = [
    pkgs.rustdesk-flutter
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
    
    # Optional: If you have a domain name or public IP, put it here.
    # Otherwise, it defaults to your local setup.
    # relay.ip = "your.public.ip.or.domain"; 

  # Data will automatically be stored securely in /var/lib/rustdesk-server
}