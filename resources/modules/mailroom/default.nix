{ config, pkgs, ... }:

let
  uiFiles = pkgs.writeTextDir "index.html" (builtins.readFile ./index.html);
  
  # The Python script that handles the "Echo" logic
  logServer = pkgs.writeScriptBin "log-server" ''
    #!${pkgs.python3}/bin/python3
    from http.server import BaseHTTPRequestHandler, HTTPServer
    import json

    class Handler(BaseHTTPRequestHandler):
        def do_OPTIONS(self): # Handles CORS so the browser allows the request
            self.send_response(200)
            self.send_header('Access-Control-Allow-Origin', '*')
            self.send_header('Access-Control-Allow-Methods', 'POST')
            self.send_header('Access-Control-Allow-Headers', 'Content-Type')
            self.end_headers()

        def do_POST(self):
            content_length = int(self.headers['Content-Length'])
            data = json.loads(self.rfile.read(content_length))
            
            # The 'Echo' logic: writing to the chosen file
            filename = f"/tmp/{data['file']}.log"
            with open(filename, "a") as f:
                f.write(f"Message received: {data['message']}\n")
            
            self.send_response(200)
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(b"OK")

    print("Logging server started on port 2113...")
    HTTPServer(('0.0.0.0', 2113), Handler).serve_forever()
  '';
in
{
  # 1. The Web UI (Port 2112)
  services.nginx = {
    enable = true;
    virtualHosts."messages.local" = {
      listen = [{ addr = "0.0.0.0"; port = 2112; }];
      root = "${uiFiles}";
    };
  };

  # 2. The Backend Service (Port 2113)
  systemd.services.message-logger = {
    description = "Backend for Island Message Center";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${logServer}/bin/log-server";
      Restart = "always";
      # Running as a dynamic user for security
      DynamicUser = true;
      # Allow writing to /tmp
      PrivateTmp = false; 
    };
  };
}