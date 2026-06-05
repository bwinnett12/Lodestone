
  #### Sunshine + Moonbeam server
{ config, pkgs, inputs, ... }:

{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # Necessary for GPU hardware capture paths
    openFirewall = true; # Automatically opens streaming ports (47984-48010)

	package = pkgs.sunshine.override {
      cudaSupport = false;
      stdenv = pkgs.stdenv;
    };
  };

  systemd.user.services.sunshine = {

	#description = "Sunshine self-hosted game stream host for Moonlight";
    wantedBy = [ "graphical-session.target" ];

    environment = {
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "GNOME";
	  LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/opengl-driver-32/lib";
	  LIBVA_DRIVER_NAME = "nvidia";

    };
  };

  security.wrappers.sunshine = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_admin+ep";
    source = "${pkgs.sunshine}/bin/sunshine";
  };


  systemd.user.services.sunshine.unitConfig.ConditionUser = "tarobutter";
  environment.systemPackages = with pkgs; [
    ];
}

