## Not yet implemented
{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.services.tailscale;
in
{
  options.services.tailscale = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Tailscale (tailscaled + tailscale CLI).";
    };
    authKey = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Optional Tailscale machine auth key (tskey-...). Prefer secrets/activation-time injection.";
    };
    advertiseExitNode = mkOption {
      type = types.bool;
      default = false;
      description = "Advertise this host as an exit node.";
    };
    stateFile = mkOption {
      type = types.str;
      default = "/var/lib/tailscale/tailscaled.state";
      description = "Path to tailscaled state file.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.tailscale ];

    systemd.services.tailscaled = {
      enable = true;
      description = "Tailscale daemon";
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.tailscale}/sbin/tailscaled --state=${cfg.stateFile}";
        Restart = "on-failure";
        User = "root";
      };

      wantedBy = [ "multi-user.target" ];
    };

    # Activation script to bring the node up if an auth key is available.
    system.activationScripts.tailscale-up = {
      text = ''
        mkdir -p $(dirname ${cfg.stateFile})
        chown -R root:root $(dirname ${cfg.stateFile}) || true
        # Prefer module option, fallback to TA_AUTH_KEY env var at activation time
        AUTHKEY=${if cfg.authKey == null then '${lib.escapeShellArg (lib.getEnv "TA_AUTH_KEY" or "")}' else ${lib.escapeShellArg cfg.authKey}}
        if [ -n "$AUTHKEY" ]; then
          ${pkgs.tailscale}/bin/tailscale up --authkey="$AUTHKEY" ${if cfg.advertiseExitNode then "--advertise-exit-node" else ""} || true
        fi
      '';
    };

    # Basic firewall guidance: do not open Tailscale ports on public interface.
    networking.firewall.allowedTCPPorts = lib.mkIf true [];
  };
}
