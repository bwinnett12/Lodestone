
#### The Mailroom. Based on Loco
{ config, pkgs, inputs, ... }:

## TODO - Replace tarobutter with Pomona

{
  
  systemd.services.mailroom = {
    description = "Mailroom - Server built on Genie with Julia";
    after = [ "network.target" ];
    wantedBy = [ "multi-`user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.julia-bin}/bin/julia --project=/home/tarobutter/Projects/Mailroom /home/tarobutter/Projects/Mailroom/bootstrap.jl";
      Restart = "on-failure";
      RestartSec = "5s";

      User = "tarobutter";
      WorkingDirectory = "/home/tarobutter/Projects/Mailroom";
    };
    environment = {
      LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib pkgs.zlib ]}";
    };
  };

}


