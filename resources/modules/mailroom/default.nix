# resources/modules/mailroom/default.nix
{ inputs, ... }: {
  imports = [ inputs.mailroom.nixosModules.default ];

  systemd.services.mailroom = {
    enable      = true;
    wantedBy = [ "multi-user.target" ];
    vaultPath   = "/storage/Tulip/shortstack/mailroom/vault";
    libraryRoot = "/storage/Orchard";
    llmUrl      = "http://127.0.0.1:8090";
  };
}