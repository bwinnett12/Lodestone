{ config, pkgs, lib, ... }:

let
  cfg = config.services.tutor-lang;
in
{
  options = {
    services.tutor-lang = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the language tutoring service (depends on gpt-neo-llm).";
      };
      listenAddr = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Address for the tutor REST API.";
      };
      listenPort = lib.mkOption {
        type = lib.types.int;
        default = 8081;
        description = "Port for the tutor API.";
      };
      modelServerUrl = lib.mkOption {
        type = lib.types.str;
        default = "http://127.0.0.1:8080";
        description = "URL of the LLM model server provided by gpt-neo-llm module.";
      };
      user = lib.mkOption {
        type = lib.types.str;
        default = "tutor";
        description = "System user to run the tutor service.";
      };
      uid = lib.mkOption {
        type = lib.types.int;
        default = 9201;
        description = "UID for the tutor user.";
      };
    };
  };

  config = lib.mkIf cfg.enable ({
    users.users = {
      "${cfg.user}" = {
        isSystemUser = true;
        uid = cfg.uid;
        createHome = true;
        home = "/var/lib/tutor-lang";
      };
    };

    environment.systemPackages = with pkgs; [
      pkgs.python310Full
      pkgs.curl
    ];

    systemd.services.tutor-lang = {
      description = "Language tutor service that proxies prompts to LLM";
      wants = [ "gpt-neo-llm.service" ];
      after = [ "gpt-neo-llm.service" ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        WorkingDirectory = "/var/lib/tutor-lang";
        ExecStart = "${pkgs.python310Full}/bin/python -u /var/lib/tutor-lang/tutor_app.py";
        Restart = "on-failure";
        RestartSec = "5s";
      };
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p /var/lib/tutor-lang
        chown -R ${cfg.user}:${cfg.user} /var/lib/tutor-lang
      '';
    };

    environment.etc."tutor-lang/tutor_app.py".text = ''
      #!/usr/bin/env python3
      import os, json, requests, sys
      from http.server import BaseHTTPRequestHandler, HTTPServer

      HOST = os.environ.get("LISTEN_ADDR", "${cfg.listenAddr}")
      PORT = int(os.environ.get("LISTEN_PORT", "${toString cfg.listenPort}"))
      MODEL_SERVER = os.environ.get("MODEL_SERVER", "${cfg.modelServerUrl}")

      # Simple in-memory session store (replace with DB for persistence)
      sessions = {}

      def make_prompt(lang_from, lang_to, level, user_text, role="tutor"):
          # A template prompt for tutoring: instruction + user text + desired task
          return f"""You are a helpful language tutor. The student is learning {lang_to} from {lang_from}. The student's level is {level}.
      Task: Provide a short correction/explanation and then produce a practice exercise (1-2 sentences) and a model answer.
      Student input: {user_text}
      Format the output as JSON with keys: corrected, explanation, exercise, model_answer.
      """

      class Handler(BaseHTTPRequestHandler):
          def _set_headers(self, code=200):
              self.send_response(code)
              self.send_header('Content-type','application/json')
              self.end_headers()

          def do_POST(self):
              length = int(self.headers.get('content-length', 0))
              body = self.rfile.read(length)
              try:
                  payload = json.loads(body)
              except:
                  self._set_headers(400)
                  self.wfile.write(json.dumps({'error':'bad json'}).encode())
                  return

              user_text = payload.get('text','')
              lang_from = payload.get('from','en')
              lang_to = payload.get('to','es')
              level = payload.get('level','A2')
              prompt = make_prompt(lang_from, lang_to, level, user_text)
              # Forward to model server
              resp = requests.post(MODEL_SERVER, json={'prompt':prompt, 'max_tokens':200}, timeout=30)
              if resp.status_code != 200:
                  self._set_headers(502)
                  self.wfile.write(json.dumps({'error':'model_server_error', 'detail': resp.text}).encode())
                  return
              model_out = resp.json().get('text','')
              # naive attempt to parse JSON from model output
              try:
                  jstart = model_out.find('{')
                  jend = model_out.rfind('}') + 1
                  extracted = json.loads(model_out[jstart:jend])
              except Exception:
                  extracted = {'raw': model_out}
              self._set_headers(200)
              self.wfile.write(json.dumps({'result': extracted}).encode())

          def log_message(self, format, *args):
              return

      def run():
          server = HTTPServer((HOST, PORT), Handler)
          print(f"Tutor API serving on {HOST}:{PORT}")
          server.serve_forever()

      if __name__ == '__main__':
          run()
    '';

    system.activationScripts.tutor-chmod = {
      text = ''
        chmod +x /etc/tutor-lang/tutor_app.py || true
      '';
    };

  });
}

