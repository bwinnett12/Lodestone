## configurations/general/office/default.nix
## Office and Productivity profiles
{ config, lib, pkgs, ... }:
let
  cfg = config.profiles.office;
in {
  options.profiles.office = {
    enable = lib.mkEnableOption "A profile for office tools and productivity";

    # libreoffice
    libreoffice = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Include the libreoffice ecosystem";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = 
         lib.optionals cfg.libreoffice [  ]
      ++                         [  ];
  };
}
