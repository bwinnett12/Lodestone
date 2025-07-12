# Minimal configuration to test user setup

{ config, pkgs, ... }:

{
  imports = [
    # Crucial to include the hardware configuration for a bootable system
    ./hardware-configuration.nix
  ];

  # System version. Align this with your actual channel (or what flake.lock hints at)
  system.stateVersion = "25.05"; # Keeping it 25.05 as your flake.lock implies unstable/future 25.05

  # Enable experimental features for flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Define user accounts
  users.groups.users = {};

  users.users.tarobutter = {
    isNormalUser = true;
    description = "tarobutter";
    group = "users";
    extraGroups = [ "wheel" "networkmanager" ]; # Essential groups
  };
}
