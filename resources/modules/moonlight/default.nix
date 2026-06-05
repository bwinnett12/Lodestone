
  #### Sunshine + Moonbeam server
{ config, pkgs, inputs, ... }:

{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # Necessary for GPU hardware capture paths
    openFirewall = true; # Automatically opens streaming ports (47984-48010)
  };

  systemd.user.services.sunshine = {
    environment = {
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "GNOME";
	  LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/opengl-driver-32/lib";
    };
  };

  systemd.user.services.sunshine.unitConfig.ConditionUser = "tarobutter";

  environment.systemPackages = with pkgs; [
    ];
}

