# resources/modules/mailroom/default.nix
{ inputs, ... }: {
  imports = [ inputs.mailroom.nixosModules.default ];

  systemd.services.mailroom = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "pomona";
      ExecStart = "";
    };
  };
}