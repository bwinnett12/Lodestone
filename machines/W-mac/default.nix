## machines/W-Mac/default.nix
{
  pkgs,
  ...
}: {

  imports = [
    
  ];
  # Native ARM Linux builder — replaces Loom's QEMU-emulated aarch64 builds
  nix.linux-builder.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Trust yourself as a Nix user (mirrors your NixOS machines' trusted-users setting)
  nix.settings.trusted-users = [ "root" "tarobutter" ];

  networking.hostName = "W-Mac";

  # Allow remote builds to target this machine over SSH
  services.openssh.enable = true;

  # Required for nix-darwin — bump only on major macOS/nix-darwin upgrades, not routine rebuilds
  system.stateVersion = 5;

  # macOS-appropriate primary user (nix-darwin needs this since 24.11+)
  system.primaryUser = "b"
}