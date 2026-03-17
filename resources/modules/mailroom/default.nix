{ config, pkgs, ... }:

let
  uiFiles = pkgs.writeTextDir "index.html" (builtins.readFile ./index.html);
  
  logServer = pkgs.writeScriptBin "log-server" ''
    #!${pkgs.python3}/bin/python3
    from http.server import BaseHTTPRequestHandler, HTTPServer
    import json
    import os

    class Handler(BaseHTTPRequestHandler):
        def do_OPTIONS(self):
            self.send_response(200)
            self.send_header('Access-Control-Allow-Origin', '*')
            self.send_header('Access-Control-Allow-Methods', 'POST')
            self.send_header('Access-Control-Allow-Headers', 'Content-Type')
            self.end_headers()

        def do_POST(self):
            content_length = int(self.headers['Content-Length'])
            data = json.loads(self.rfile.read(content_length))
            
            # Use a persistent path
            log_dir = "/var/log/messages-app"
            filename = os.path.join(log_dir, f"{data['file']}.log")
            
            with open(filename, "a") as f:
                f.write(f"Message: {data['message']}\n")
            
            self.send_response(200)
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(b"Logged successfully")

    HTTPServer(('0.0.0.0', 2113), Handler).serve_forever()
  '';
in
{
  # Open the ports in the firewall
  networking.firewall.allowedTCPPorts = [ 2112 2113 ];

  services.nginx = {
    enable = true;
    virtualHosts."messages.local" = {
      listen = [{ addr = "0.0.0.0"; port = 2112; }];
      root = "${uiFiles}";
    };
  };

  systemd.services.message-logger = {
    description = "Backend for Island Message Center";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    
    # Create the logging directory before the script starts
    preStart = ''
      mkdir -p /var/log/messages-app
      chmod 777 /var/log/messages-app
    '';

    serviceConfig = {
      ExecStart = "${logServer}/bin/log-server";
      Restart = "always";
      User = "root"; # Simplified for writing to /var/log
    };
  };
}