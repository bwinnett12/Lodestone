
#### The Mailroom - Server built on Genie with Julia

{ config, pkgs, inputs, ... }:

let
  # 1. Define your variables here
  user = "pomona";
  # Adjust this path once you move to the orchid drive
  mailroom-dir = "/storage/Orchid/shortstack/Mailroom"; 
  # Example for the new drive: basePath = "/mnt/storage-orchid/Mailroom";
in
{
  systemd.services.mailroom = {
    description = "Mailroom - Server built on Genie with Julia";

    # Ensures the drive is mounted before trying to start
    after = [ "network.target" "storage-orchid.mount" ]; 
    requires = [ "storage-orchid.mount" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {

      User = "${user}";
      WorkingDirectory = "${mailroom-dir}";
      ReadWritePaths = [ "${mailroom-dir}" ];
      
      ExecStart = "${pkgs.julia-bin}/bin/julia --project=${mailroom-dir} ${mailroom-dir}/bootstrap.jl";
      Restart = "on-failure";
      RestartSec = "5s";

    };
    environment = {
      LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib pkgs.zlib ]}";
    };
  };
}