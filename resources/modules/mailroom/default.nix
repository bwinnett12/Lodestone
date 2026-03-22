
#### The Mailroom. Based on Loco
{ config, pkgs, inputs, ... }:

{
  
  systemd.services = {
    mailroom-server = {
      description = "Mailroom Loco API Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        # Path to where Cargo.toml and flake.nix live
        WorkingDirectory = "/home/tarobutter/Projects/Mailroom";
        
        # Use 'nix run' to ensure all flake dependencies are loaded
        # The '.' tells nix to run the default package defined in your flake
        ExecStart = "${pkgs.nix}/bin/nix run . -- start";
        
        Restart = "always";
        User = "tarobutter";
        Environment = "LOCO_ENV=development";
      };
    };

    mailroom-worker = {
      description = "Mailroom AI Worker Processor";
      after = [ "network.target" "mailroom-server.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        WorkingDirectory = "/home/tarobutter/Projects/Mailroom";
        
        # Passing the --worker flag through nix run
        ExecStart = "${pkgs.nix}/bin/nix run . -- start --worker";
        
        Restart = "always";
        User = "tarobutter";
        Environment = "LOCO_ENV=development";
      };
    };
};


}


