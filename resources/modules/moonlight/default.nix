
  #### Sunshine + Moonbeam server
{ config, pkgs, inputs, ... }:

{

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;   # Gives Sunshine kernel permission to capture your GPU frames
    openFirewall = true;  # Automatically opens streaming ports (47984-48010)

    package = if pkgs.stdenv.hostPlatform.isAarch64
      then pkgs.sunshine
      else pkgs.sunshine.override { cudaSupport = true; };
  };

  systemd.user.services.sunshine.unitConfig = {
    ConditionUser = "tarobutter";
  };

  hardware.uinput.enable = true;
  #users.users.tarobutter.extraGroups = [ "uinput" "input" ];

  environment.systemPackages = with pkgs; [
    gnome-randr
  ];

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 47984 47989 48010 47990 ];
}

