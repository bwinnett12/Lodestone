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
    llmUrl      = "http://ai.platatoo.com";
    summariseModel = "qwen_qwen3.5-0.8b";
  };
  users.users.mailroom.extraGroups = [ "storage" ];

  # nginx reverse proxy
  services.nginx = {
    enable = true;
    virtualHosts."mail.platatoo.com" = {
      listen = [{ addr = "100.106.125.87"; port = 80; }]; ## This is Locomotive
      locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
      }; }; };
}