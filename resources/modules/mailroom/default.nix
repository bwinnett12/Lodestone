# resources/modules/mailroom/default.nix
{ inputs, pkgs, ... }: {
  imports = [ 
    inputs.mailroom.nixosModules.default 
    ./homepage.nix
  ];

  services.mailroom = {
    enable      = true;
    vaultPath   = "/storage/Orchard";
    libraryRoot = "/storage/Orchard";
    llmUrl      = "http://loom.tail4b1127.ts.net";
    listenAddr  = "0.0.0.0:8095";
    summariseModel = "qwen_qwen3.5-0.8b";
  };
  users.users.mailroom.extraGroups = [ "storage" ];

  # nginx reverse proxy
  services.nginx = {
    enable = true;
    virtualHosts."mail.platatoo.com" = {
      listen = [{ addr = "100.106.125.87"; port = 80; }];
      locations."/" = {
        proxyPass = "http://127.0.0.1:8095";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };

    # ← ADD HTTPS vhost for Tailscale
    virtualHosts."locomotive.tail4b1127.ts.net" = {
      listen = [{ addr = "100.106.125.87"; port = 443; ssl = true; }];
      sslCertificate = "/etc/ssl/certs/mailroom-tailscale.crt";
      sslCertificateKey = "/etc/ssl/private/mailroom-tailscale.key";
      locations."/" = {
        proxyPass = "http://127.0.0.1:8095";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };

  # Create SSL directories
  systemd.tmpfiles.rules = [
    "d /etc/ssl/certs 0755 root root -"
    "d /etc/ssl/private 0700 root root -"
  ];

  # Auto-generate cert for Mailroom only
  systemd.services."mailroom-tls-cert" = {
    description = "Generate self-signed TLS cert for Mailroom";
    wantedBy = [ "multi-user.target" ];
    before = [ "nginx.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        bash -c 'if [ ! -f /etc/ssl/certs/mailroom-tailscale.crt ]; then
          ${pkgs.openssl}/bin/openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
            -keyout /etc/ssl/private/mailroom-tailscale.key \
            -out /etc/ssl/certs/mailroom-tailscale.crt \
            -subj "/CN=locomotive.tail4b1127.ts.net" 2>/dev/null
        fi'
      '';
      RemainAfterExit = true;
    };
  };
}