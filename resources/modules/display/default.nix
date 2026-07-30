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
   (lib.mkIf cfg.gnome.enable (lib.mkMerge [
    {
      services.desktopManager.gnome.enable = true;
      services.displayManager.gdm.enable = true;
      services.gnome.core-apps.enable = false;
      services.gnome.core-developer-tools.enable = false;
      services.gnome.games.enable = false;
      environment.gnome.excludePackages = with pkgs; [
        gnome-tour
        gnome-user-docs
        gnome-photos
        gnome-music
        gnome-contacts
        gnome-maps
        gnome-weather
        epiphany
        geary
        gnome-characters
        totem
      ];
    }
    (lib.mkIf config.ecosystem.power.portable.enable {
      environment.systemPackages = with pkgs; [ gnome-wlr ];
    })
  ]))


    # COSMIC
    # Uses auto-cpufreq, ignore the power applet limitation
    (lib.mkIf cfg.cosmic.enable {

      services = {
        desktopManager.cosmic.enable = true;
        displayManager.cosmic-greeter.enable = true;
        # power-profiles-daemon.enable = true;
        # power-profiles-daemon.enable = lib.mkDefault true;
        # auto-cpufreq.enable = lib.mkDefault false;
      };
    })

      #environment.systemPackages = [
      #  pkgs.OpenTabletDriver ## TODO - Add this to a tablet module
  ]);  
}
