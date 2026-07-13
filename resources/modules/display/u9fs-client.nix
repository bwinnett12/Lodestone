# resources/modules/u9fs-client.nix
# Deploy on Locomotive — mounts Island's storage at /storage/Library.
# Uses systemd automount — safe when Island is offline.

{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.services.u9fs-client;
in {

  options.services.u9fs-client = {
    enable = lib.mkEnableOption "u9fs 9P client mount";

    mountPoint = lib.mkOption {
      type        = lib.types.str;
      default     = "/storage/Orchard";
      description = ''
        Where Island's storage appears on the client device.
        Mailroom reads and writes here as if local.
        Created automatically at boot.
      '';
    };

    serverIP = lib.mkOption {
      type        = lib.types.str;
      description = ''
        Tailscale IP of Island (the u9fs server).
        Run on Island: tailscale ip -4
      '';
    };

    port = lib.mkOption {
      type        = lib.types.port;
      default     = 4500;
      description = "Must match u9fs-server.port on Island.";
    };

    timeoutSec = lib.mkOption {
      type        = lib.types.int;
      default     = 10;
      description = ''
        Seconds before giving up on a mount attempt.
        Lower = faster failure detection when Island is offline.
        The Mailroom receives a clean error and logs it.
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    # ── Create mount point ───────────────────────────────────────────────────
    systemd.tmpfiles.rules = [
      "d ${cfg.mountPoint} 0755 root root -"
    ];

    # ── Automount unit ───────────────────────────────────────────────────────
    # Only activates when something accesses the path.
    # If Island is offline, access fails after timeoutSec
    # rather than hanging Locomotive's boot.
    systemd.automounts = [{
      where    = cfg.mountPoint;
      wantedBy = [ "multi-user.target" ];

      automountConfig = {
        TimeoutIdleSec = toString cfg.timeoutSec;
        # Unmount automatically after this many seconds of inactivity.
        # Next access remounts on demand — keeps the connection fresh.
      };
    }];

    # ── Mount unit ───────────────────────────────────────────────────────────
    systemd.mounts = [{
      where  = cfg.mountPoint;
      what   = "${cfg.serverIP}";
      # For 9P over TCP, `what` is just the server address.
      # The port goes in options below.

      type    = "9p";
      options = lib.concatStringsSep "," [
        "trans=tcp"
        # TCP transport — correct for network 9P over Tailscale.

        "port=${toString cfg.port}"
        # The port u9fs listens on.

        "version=9p2000.L"
        # Linux extended 9P — supports large files and proper permissions.

        "uname=u9fs"
        # Username presented to the server.
        # Must match the user u9fs runs as on Island.

        "access=user"
        # Map file ownership to the local accessing user.

        "_netdev"
        # This is a network mount — don't attempt before network is up,
        # unmount cleanly before network goes down.

        "noauto"
        # Don't mount at boot — let the automount unit handle it.
        # This is what makes Island going offline safe.
      ];

      after = [
        "tailscaled.service"
        "network-online.target"
      ];
      wants = [ "network-online.target" ];
    }];
  };
}