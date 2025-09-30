{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.localai;
in
{
  options.services.localai = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Run LocalAI server (single-binary inference server).";
    };
    version = mkOption {
      type = types.str;
      default = "v0.11.1";
      description = "LocalAI release tag or version string to download/build.";
    };
    modelDir = mkOption {
      type = types.str;
      default = "/var/lib/localai/models";
      description = "Directory to place model files for LocalAI to load.";
    };
    listenAddr = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "Address LocalAI should bind to.";
    };
    listenPort = mkOption {
      type = types.int;
      default = 8080;
      description = "Port LocalAI should bind to.";
    };
    user = mkOption {
      type = types.str;
      default = "localai";
      description = "System user to run LocalAI.";
    };
    uid = mkOption {
      type = types.int;
      default = 9300;
      description = "User id for LocalAI user.";
    };
    binaryPath = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Optional path to a prebuilt LocalAI binary. If null, module downloads a released binary.";
    };
    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional commandline arguments to pass to LocalAI.";
    };
  };

  config = mkIf cfg.enable ({
    users.users = {
      "${cfg.user}" = {
        isSystemUser = true;
        uid = cfg.uid;
        createHome = true;
        home = "/var/lib/localai";
        description = "LocalAI service user";
      };
    };

    environment.systemPackages = with pkgs; [
      pkgs.curl
      pkgs.wget
      pkgs.unzip
      pkgs.jq
    ];

    # Create model dir
    environment.etc."localai/.placeholder".text = "localai placeholder";

    systemd.services.localai = {
      description = "LocalAI inference server";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        WorkingDirectory = "/var/lib/localai";
        ExecStart = ''
          ${if cfg.binaryPath != null then cfg.binaryPath else "${pkgs.curl}/bin/curl"} \
            ${if cfg.binaryPath != null then "" else "-sSfL https://github.com/mudler/LocalAI/releases/download/${cfg.version}/localai-linux-amd64.tar.gz | tar xz -C /var/lib/localai --strip-components=1 && /var/lib/localai/localai"} \
            ${concatStringsSep " " (map (s: " " + builtins.toString s) (["--host", cfg.listenAddr, "--port", toString cfg.listenPort] ++ cfg.extraArgs))}
        '';
        Restart = "on-failure";
        RestartSec = "5s";
      };
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p ${cfg.modelDir}
        chown -R ${cfg.user}:${cfg.user} /var/lib/localai ${cfg.modelDir}
      '';
    };

    # Put a simple systemd tmpfile to ensure model dir exists
    systemd.tmpfiles.rules = [
      "d ${cfg.modelDir} 0755 ${cfg.user} ${cfg.user} - -"
    ];
  });
}

