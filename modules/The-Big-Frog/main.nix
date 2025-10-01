# modules/The-Big-Frog/main.nix
{ config, pkgs, ... }:

{
  # This option merges the configurations from the two sub-modules.
  # The Nix evaluator handles the merging of all options (services, environment.systemPackages, etc.).
  imports = [
    #./gpt-neo.nix
    #./tutor-lang.nix
    ./jellyfin.nix
  ];

  # You can still add other suite-wide settings here if needed
  # Example:
  # environment.systemPackages = [ pkgs.tmux ];
}