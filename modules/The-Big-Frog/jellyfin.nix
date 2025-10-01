# ./modules/The-Big-Frog/jellyfin.nix
#### Jellyfin server
{ config, pkgs, ... }:

{
  # Enable the Jellyfin service
  services.jellyfin = {
    enable = true;
    openFirewall = true;

    # Specify the user and group Jellyfin will run as.
    user = "tarobutter";
    group = "users";
  };
}
  
