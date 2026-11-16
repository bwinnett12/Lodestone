# resources/environments/neovim/system.nix
{ config, lib, pkgs, ... }:
let
  cfg = config.ecosystem.environments.neovim;
in {
  options.ecosystem.environments.neovim.enable =
    lib.mkEnableOption "Neovim coding environment";

  config = lib.mkIf cfg.enable {
    ## Language servers and formatters come from self.nixosModules.editor
    ## (ecosystem.editor.languages), shared with Zed.
    fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

    home-manager.sharedModules = [ 
      ./home.nix
    ];
  };
}