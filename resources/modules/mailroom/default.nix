# resources/modules/mailroom/default.nix
{ inputs, pkgs, ... }: {
  imports = [ 
    inputs.mailroom.nixosModules.default 
    ./homepage.nix
  ];

  services.mailroom = {
    enable      = true;
    vaultPath   = "/storage/Tulip/Orchard";
    libraryRoot = "/storage/Tulip/Orchard";
    llmUrl      = "http://loom.tail4b1127.ts.net";
    listenAddr  = "0.0.0.0:8095";
    summariseModel = "qwen_qwen3.5-0.8b";
  };
  users.users.mailroom.extraGroups = [ "storage" ];
  # nginx reverse proxy — HTTP only for now
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
  };
}