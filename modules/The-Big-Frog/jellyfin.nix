  #### Jellyfin server

  # Enable the Jellyfin service
  services.jellyfin = {
    enable = true;
    openFirewall = true;

    # Specify the user and group Jellyfin will run as.
    user = "tarobutter";
    group = "users";

    # dataDir = "/var/lib/jellyfin"; # Default is fine, uncomment if you want to change it
  };