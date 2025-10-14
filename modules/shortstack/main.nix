# modules/shortstack/main.nix
{ config, pkgs, ... }:

{
  # This option merges the configurations from the two sub-modules.
  # The Nix evaluator handles the merging of all options (services, environment.systemPackages, etc.).
  imports = [
    #./tutor-lang.nix
    ./jellyfin.nix
  ];

  # You can still add other suite-wide settings here if needed
  # Example:
  environment.systemPackages = [ pkgs.tmux ];
}