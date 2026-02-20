#### 9p server - u9fs
### Thrifted from https://github.com/justinrubek/nixos-configs

{ config, pkgs, inputs, ... }:

{

 systemd = {
    sockets.u9fs = {
      description = "9P filesystem server socket... Not the one from outer space...";
      wantedBy = ["sockets.target"];
      socketConfig = {
        ListenStream = "4500";
        Accept = "yes";
      };
    };
    services."u9fs@" = let
      mountDir = "/storage/9p"; # TODO: ensure this directory exists and is owned by this user
      user = "tarobutter";   # TODO - Replace with a user?
      package = u9fs;  # TODO: Replace with inheritable system
    in {
      description = "9P filesystem server";
      after = ["network.target"];

      serviceConfig = {
        ExecStart = "${package}/bin/u9fs -D -a none -u ${user} -d ${mountDir}";
        User = "${user}";
        StandardInput = "socket";
        StandardError = "journal";
      };
    };
  };



  # Dependencies
  environment.systemPackages = with pkgs; [
    curl
    wget
    unzip
    jq
    u9fs
  ];
  
}
