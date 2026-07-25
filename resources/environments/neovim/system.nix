# resources/environments/neovim/system.nix
{ config, lib, pkgs, ... }:
let
  cfg = config.ecosystem.environments.neovim;
in {
  options.ecosystem.environments.neovim.enable =
    lib.mkEnableOption "Neovim coding environment";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ripgrep fd nil
      nixd nixpkgs-fmt
      python312Packages.python-lsp-server
      python312Packages.pylsp-mypy
      ruff python312Packages.black
      rust-analyzer rustc cargo rustfmt clippy
      (rWrapper.override { packages = with rPackages; [ languageserver ]; })
      julia-bin
    ];
    fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

    home-manager.sharedModules = [ 
      ./home.nix
    ];
  };
}
