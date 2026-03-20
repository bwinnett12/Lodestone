

{ config, pkgs, inputs, ... }:

let
  # UI Files
  uiFiles = pkgs.writeTextDir "html-files" ''
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>NixOS Message Portal</title>
        <!-- Include the rest of the HTML here as shown above -->
    </head>
    <body>
        <div class="card">
            <h2>System Dispatcher</h2>
            <form id="dispatchForm">
                <div class="field">
                    <label>Message Payload</label>
                    <input type="text" id="payload" placeholder="Type message here..." required>
                </div>
                <div class="field">
                    <label>Destination Channel</label>
                    <select id="channel">
                        <option value="notify">Desktop Notification</option>
                        <option value="log">Systemd Journal</option>
                        <option value="localai">LocalAI Inference</option>
                    </select>
                </div>
                <button type="submit">Dispatch Message</button>
            </form>
        </div>
        <script>
            // JavaScript for handling form submission goes here
        </script>
    </body>
    </html>
  '';

  # Log Server
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
            
            # Use a persistent path for logging
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
  # Systemd and u9fs configurations remain the same
  # ...

  systemd = {
    sockets.u9fs = {
      description = "9P filesystem server socket... Not the one from outer space...";
      wantedBy = ["sockets.target"];
      socketConfig = {
        ListenStream = "4500";
        Accept = "yes";
      };
    };
    services."u9fs@" = let
      mountDir = "/storage/Well"; 
      user = "root"; 
      package = pkgs.u9fs;
    in {
      description = "9P filesystem server";
      after = ["network.target"];
      serviceConfig = {
        ExecStart = "${package}/bin/u9fs -D -a none -u ${user} -d ${mountDir}";
        User = "${user}";
        StandardInput = "socket";
        StandardError = "journal";
      };
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."messages.local" = {
      listen = [{ addr = "0.0.0.0"; port = 2112; }];
      root = "${uiFiles}";  # Root points to the new HTML files
    };
  };

  systemd.services.message-logger = {
    description = "Backend for Message Logger";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    
    preStart = ''
      mkdir -p /var/log/messages-app
      chmod 777 /var/log/messages-app
    '';

    serviceConfig = {
      ExecStart = "${logServer}/bin/log-server";
      Restart = "always";
      User = "root"; 
    };
  };

  # Dependencies
  environment.systemPackages = with pkgs; [
    curl
    wget
    unzip
    jq
    u9fs
    python3
  ];
}
