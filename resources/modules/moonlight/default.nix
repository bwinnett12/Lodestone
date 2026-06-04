
  #### Sunshine + Moonbeam server
{ config, pkgs, inputs, ... }:

{
  # Enable the Sunshine service
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # Necessary for GPU hardware capture paths
    openFirewall = true; # Automatically opens streaming ports (47984-48010)
  };


  environment.systemPackages = with pkgs; [
    ];
}

