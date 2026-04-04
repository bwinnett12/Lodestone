
#### The Mailroom - Server built on Genie with Julia

{ config, pkgs, inputs, ... }:

let
  # 1. Define your variables here
  user = "pomona";
  # Adjust this path once you move to the orchid drive
  mailroom-dir = "/storage/Orchid/shortstack/Mailroom"; 
  dbName = "mailroom_db";
  # Example for the new drive: basePath = "/mnt/storage-orchid/Mailroom";
in
{
  # 1. Enable and Configure PostgreSQL
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15; # Explicit versioning for stability
    ensureDatabases = [ "${dbName}" "${user}" ];
    ensureUsers = [
      {
        name = "${user}";
        ensureDBOwnership = true;
      }
    ];
    # Trust local socket connections for the service user
    authentication = pkgs.lib.mkForce ''
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             all                                     trust
      host    all             all             127.0.0.1/32            trust
      host    all             all             ::1/128                 trust
    '';
  };



  systemd.services.mailroom = {
    description = "Mailroom - Server built on Genie with Julia";

    # Ensures the drive is mounted before trying to start
    after = [ "network.target" "storage-orchid.mount" "postgresql.service" ]; 
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
      # 4. Pass DB credentials to Julia via ENV
      GENIE_ENV = "prod";
      DB_ADAPTER = "PostgreSQL";
      DB_HOST = "10.0.1.10";
      DB_NAME = dbName;
      DB_USER = user;
      # Since we used 'trust' for local, we don't strictly need a password here,
      # #TODO - Updated to use a secret file.





      LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [ 
        pkgs.stdenv.cc.cc.lib 
        pkgs.zlib 
        pkgs.postgresql.lib # Required for Julia's LibPQ.jl to link correctly
        ]}";
    };
  };
}