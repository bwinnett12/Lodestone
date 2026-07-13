#### Display modules 
# resources/modules/display/default.nix
{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.ecosystem.display;
in {

  options.ecosystem.display = {
    enable = lib.mkEnableOption "Implement a Display manager or Window Manager";

    gnome = lib.mkOption {
      type        = lib.types.boolean;
      default     = false;
      description = ''
        Establish the Gnome Display system.
      '';
    };

   cosmic = lib.mkOption {
     type         = lib.types.boolean;
     default      = false;
     description  = ''
       Establish the Cosmic Display System.
     '';
   };
  };


  config = lib.mkIf cfg.enable {
 ## TODO  
   
  };
}
