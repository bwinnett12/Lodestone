# resources/modules/u9fs-server.nix
{ config, lib, pkgs, inputs, ... }:

let
  cfg     = config.services.u9fs-server;
  u9fsPkg = inputs.u9fs.packages.${pkgs.stdenv.hostPlatform.system}.default;
  # Pull the u9fs binary from the justinrubek flake input.

in {
  options.services.u9fs-server = {
    enable = lib.mkEnableOption "u9fs 9P file server";

    exportPath = lib.mkOption {
      type        = lib.types.str;
      default     = "/storage/Orchard";
      description = ''
        Directory to expose over 9P.
        This is the path for the shared config.
        Created automatically at boot if missing.
      '';
    };

    port = lib.mkOption {
      type        = lib.types.port;
      default     = 4500;
      description = "Port to listen on. Only bound to Tailscale interface.";
    };

    tailscaleIP = lib.mkOption {
      type        = lib.types.str;
      description = ''
        Tailscale IP of host machine.
        Find with: tailscale ip -4
        u9fs binds only here — not reachable from public internet.
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    # ── Create export directory ──────────────────────────────────────────────
    systemd = {
      tmpfiles.rules = [
        "d ${cfg.exportPath} 0770 u9fs u9fs -"
      ];


      # ── Socket unit ──────────────────────────────────────────────────────────
      sockets.u9fs = {
        description = "u9fs 9P file server socket";
        wantedBy    = [ "sockets.target" ];

        socketConfig = {
          ListenStream = "${cfg.tailscaleIP}:${toString cfg.port}";
          # Bind to Tailscale IP only — not 0.0.0.0.
          # Only Tailscale peers can reach this.
          Accept       = "yes";
          # Spawn one u9fs process per accepted connection.
        };
      };

      # ── Service template ─────────────────────────────────────────────────────
      services."u9fs@" = {
        description = "u9fs 9P file server instance";
        after       = [ "network.target" "tailscaled.service" ];
        wants       = [ "tailscaled.service" ];

        serviceConfig = {
          ExecStart = "${u9fsPkg}/bin/u9fs -D -a none -u u9fs -d ${cfg.exportPath}";
          # -D           verbose logging to journal
          # -a none      no auth — Tailscale handles trust
          # -u u9fs      run as the u9fs system user
          # -d           the directory to export

          User           = "u9fs";
          StandardInput  = "socket";
          StandardError  = "journal";

          # ── Hardening ────────────────────────────────────────────────────
          NoNewPrivileges = true;
          ProtectSystem   = "strict";
          ProtectHome     = true;
          ReadWritePaths  = [ cfg.exportPath ];
          PrivateTmp      = true;
        };
      };

    };

    networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ cfg.port ];
    
    environment.systemPackages = with pkgs; [
      u9fsPkg
      curl
      wget
      unzip
      jq
    ];
  };
}