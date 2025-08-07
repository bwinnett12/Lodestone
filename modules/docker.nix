{ config, pkgs, ... }:

{

  ## Enable docker
  virtualisation.docker.enable = true;
  # Optionally, specify Docker images to pull
  # services.docker.images = [
  #  {
  #    name = "hello-world";
  #    tag = "latest";
  #  }
  #];
}
