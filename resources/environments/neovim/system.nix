# resources/environments/neovim/system.nix
{ config, lib, pkgs, ... }:
let
  cfg = config.ecosystem.environments.neovim;
in {
  options.ecosystem.environments.neovim.enable =
    lib.mkEnableOption "Neovim coding environment";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ripgrep fd rust-analyzer nil
    ];
    fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

    home-manager.sharedModules = [ ./home.nix ];
  };
}