
#### The Mailroom - Server built on Genie with Julia
{ config, pkgs, inputs, ... }:

## TODO - Replace tarobutter with Pomona

{
  systemd.services.mailroom = {
    description = "Mailroom - Server built on Genie with Julia";

      # Ensures the drive is mounted before trying to start
    after = [ "network.target" "storage-orchid.mount" ]; 
    requires = [ "storage-orchid.mount" ];

    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      
      ExecStart = "${pkgs.julia-bin}/bin/julia --project=/home/tarobutter/Projects/Mailroom /home/tarobutter/Projects/Mailroom/bootstrap.jl";
      Restart = "on-failure";
      RestartSec = "5s";

      User = "tarobutter";
      WorkingDirectory = "/home/tarobutter/Projects/Mailroom";
      ReadWritePaths = [ "/home/tarobutter/Projects/Mailroom" ];

    };
    environment = {
      LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib pkgs.zlib ]}";
    };
  };


  systemd.services.mailroom = {

  
  serviceConfig = {
    WorkingDirectory = "/mnt/data/Mailroom";
    ExecStart = "${pkgs.julia-bin}/bin/julia --project=/mnt/data/Mailroom /mnt/data/Mailroom/bootstrap.jl";
    # ... rest of config
  };
};

}


