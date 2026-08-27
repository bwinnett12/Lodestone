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
}