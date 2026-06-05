
  #### Sunshine + Moonbeam server
{ config, pkgs, inputs, ... }:

{

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;   # Gives Sunshine kernel permission to capture your GPU frames
    openFirewall = true;  # Automatically opens streaming ports (47984-48010)
    package = pkgs.sunshine;
  };

  systemd.user.services.sunshine.unitConfig = {
    ConditionUser = "tarobutter";
  };

  hardware.uinput.enable = true;
  #users.users.tarobutter.extraGroups = [ "uinput" "input" ];

}

