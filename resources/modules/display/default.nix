## resources/modules/display/default.nix
#### Display modules 
{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.ecosystem.display;
  
  import = [ 
    #./fonts
  ];
in {

  options.ecosystem.display = {
    enable = lib.mkEnableOption "Implement a Display manager or Window Manager";

    gnome = { enable = lib.mkEnableOption "Establish the GNOME display system"; };
    cosmic = { enable = lib.mkEnableOption "Establish the Cosmic display system"; };
  };


  config = lib.mkIf cfg.enable (lib.mkMerge [
    # Common Display
    {

      services = {
        xserver = { 
          enable = true; 
          xkb = {
            layout = "us";
            variant = "";
          };
        };
      };
    }
    
      # GNOME
    (lib.mkIf cfg.gnome.enable {

      services = {
        xserver.desktopManager.gnome.enable = true;
        xserver.displayManager.gdm.enable = true;
        power-profiles-daemon.enable = lib.mkDefault false;
        auto-cpufreq = { 
          enable = true;
          settings = {
            battery = {
              governor = "powersave";
              turbo = "never";
            };
            charger = {
              governor = "performance";
              turbo = "auto";
            };
          };
        };
      };

      environment.systemPackages = [ ];
    })

    # COSMIC
    # Uses auto-cpufreq, ignore the power applet limitation
    (lib.mkIf cfg.cosmic.enable {

      services = {
        desktopManager.cosmic.enable = true;
        displayManager.cosmic-greeter.enable = true;
        power-profiles-daemon.enable = true;
        # power-profiles-daemon.enable = lib.mkDefault true;
        # auto-cpufreq.enable = lib.mkDefault false;
      };
    })

      #environment.systemPackages = [
      #  pkgs.OpenTabletDriver ## TODO - Add this to a tablet module
  ]);  
}
