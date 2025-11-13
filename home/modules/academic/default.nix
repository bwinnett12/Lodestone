### Academic
### ./modules/academic/default.nix

{ config, lib, pkgs, ... }:

let

  cfg = config.profiles.academic;

in {
  options.profiles.academic = {
    enable = lib.mkEnableOption "Profile for Academic Research";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.zotero
    ];
  };
}