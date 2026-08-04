# resources/modules/mailroom/default.nix
{ inputs, ... }: {
  imports = [ 
    inputs.mailroom.nixosModules.default 
    ./homepage.nix
  ];

  services.mailroom = {
    enable      = true;
    vaultPath   = "/storage/Orchard";
    libraryRoot = "/storage/Orchard";
    llmUrl      = "http://loom.tail4b1127.ts.net";
    listenAddr  = "0.0.0.0:8095";   # pick something free — 8090 is already used by LocalAI on Loom, so maybe 8100
    summariseModel = "qwen_qwen3.5-0.8b";
  };
  users.users.mailroom.extraGroups = [ "storage" ];

  # nginx reverse proxy
  services.nginx = {
    enable = true;
    virtualHosts."mail.platatoo.com" = {
      listen = [{ addr = "100.106.125.87"; port = 80; }]; ## This is Locomotive
      locations."/" = {
          proxyPass = "http://127.0.0.1:8095";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
      }; }; };
}