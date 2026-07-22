# resources/modules/mailroom/default.nix
{ inputs, ... }: {
  imports = [ inputs.mailroom.nixosModules.default ];

  services.mailroom = {
    enable      = true;
    vaultPath   = "/storage/Orchard";
    libraryRoot = "/storage/Orchard";
    llmUrl      = "http://ai.platatoo.com/";
  };

  users.users.mailroom.extraGroups = [ "storage" ];
}