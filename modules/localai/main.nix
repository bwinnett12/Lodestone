{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.localai;
  localaiBasePath = builtins.substring 0 (builtins.stringLength cfg.modelDir - builtins.stringLength "/models") cfg.modelDir;
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
    tarballSha256 = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "sha256 of the release tarball (set to null to use the fetching helper to find it during first build).";
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
      description = "Optional path to a prebuilt LocalAI binary. If null, module will fetch a released binary at build time.";
    };
    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional commandline arguments to pass to LocalAI.";
    };
  };

  config = mkIf cfg.enable (let

    binaryUrl = "https://github.com/mudler/LocalAI/releases/download/${cfg.version}/local-ai-${cfg.version}-linux-amd64";


    # Use fetchurl for a reproducible download.
    # If cfg.tarballSha256 is null, we use a placeholder (lib.fakeSha256) so the build fails
    # and prints the correct hash to put in configuration.
    binarySrc = if cfg.tarballSha256 != null then
      pkgs.fetchurl {
        url = binaryUrl;
        sha256 = cfg.tarballSha256;
      }
    else
      pkgs.fetchurl {
        url = binaryUrl;
        sha256 = lib.fakeSha256;
      };

    localai-bin = pkgs.runCommand "localai-binary-${cfg.version}" { } ''
      mkdir -p $out/bin
      install -m755 ${binarySrc} $out/bin/localai
    '';

    localaiStorePath = "${localai-bin}/bin/localai";
    execStartCmd = if cfg.binaryPath != null then cfg.binaryPath else localaiStorePath;
  argsList = ["run" "--port" (toString cfg.listenPort)] ++ cfg.extraArgs;
  
  in {
    users.users = {
      "${cfg.user}" = {
        isSystemUser = true;
        uid = cfg.uid;
        createHome = true;
        home = localaiBasePath;
        description = "LocalAI service user";
        group = "localai";
      };
    };

    environment.systemPackages = with pkgs; [
      curl
      wget
      unzip
      jq
    ];

    environment.etc."localai/.placeholder".text = "localai placeholder";

    systemd.services.localai = {
      description = "LocalAI inference server";
      # ADD dependencies on the mount point if /storage/Orchid is a separate drive
      # This requires the fileSystems mount to be configured in configuration.nix
      # The mount unit name is based on the path: /storage/Orchid -> storage-Orchid.mount
      after = [ "network.target" /* "storage-Orchid.mount" */ ]; 
      wants = [ "network.target" /* "storage-Orchid.mount" */ ];
      # requires = [ "storage-Orchid.mount" ]; # Use requires if the mount is absolutely critical for the service to function

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        # CHANGE: Use the calculated base path as the WorkingDirectory
        WorkingDirectory = localaiBasePath; 
        ExecStart = ''
          ${execStartCmd} ${concatStringsSep " " argsList}
        '';
        Restart = "on-failure";
        RestartSec = "5s";
      };
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        # This will now create and ensure ownership on the new path
        mkdir -p ${cfg.modelDir}
        chown -R ${cfg.user}:${cfg.user} ${localaiBasePath} ${cfg.modelDir}
      '';
    };
  });
}