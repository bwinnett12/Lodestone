# resources/modules/mailroom/default.nix
{ inputs, ... }: {
  imports = [ inputs.mailroom.nixosModules.default ];

  services.mailroom = {
    enable      = true;
    vaultPath   = "/var/lib/mailroom/vault";
    libraryRoot = "/storage/Orchard";
    llmUrl      = "http://ai.platatoo.com/";
  };
}