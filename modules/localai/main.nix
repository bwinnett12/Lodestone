{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.localai;
  localaiBasePath = builtins.substring 0 (builtins.stringLength cfg.modelDir - builtins.stringLength "/models") cfg.modelDir;

  # --- START OF REINSTATED DOWNLOAD/BUILD LOGIC ---

  # 1. Define the URL for the desired pre-built binary.
  # CRITICAL FIX 1: Change to the URL that is more likely to include all C++ backends, 
  # and set the version higher to avoid known bugs.
  binaryUrl = "https://github.com/mudler/LocalAI/releases/download/${cfg.version}/local-ai-${cfg.version}-linux-amd64"; 

  # 2. Use fetchurl for a reproducible download.
  # If tarballSha256 is null, it uses a placeholder to force a hash to be printed.
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

  # 3. Package the downloaded binary into the Nix store.
  localai-bin = pkgs.runCommand "localai-binary-${cfg.version}" { } ''
    mkdir -p $out/bin
    install -m755 ${binarySrc} $out/bin/localai
  '';

  # 4. Define variables needed by the service configuration (Moved from internal 'config' let block)
  localaiStorePath = "${localai-bin}/bin/localai";
  execStartCmd = if cfg.binaryPath != null then cfg.binaryPath else localaiStorePath;
  argsList = ["run"] ++ cfg.extraArgs;

  # --- END OF REINSTATED DOWNLOAD/BUILD LOGIC ---

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
      default = "v3.6.0";
      description = "LocalAI release tag or version string to download/build.";
    };
    tarballSha256 = mkOption {
      type = types.nullOr types.str;
      default = "sha256-2cWoaX82WSLPYcaeIPRQSu/U/tzdqKxodq5YkvYBXmM=";
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

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      curl
      wget
      unzip
      jq
    ];

    environment.etc."localai/.placeholder".text = "localai placeholder";

    systemd.services.localai = {
      description = "LocalAI inference server";
      after = [ "network.target" "storage-Orchid.mount" ]; 
      wants = [ "network.target" "storage-Orchid.mount" ]; 

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        WorkingDirectory = localaiBasePath;
        ExecStartPre = ""; # Kept empty to prevent chown conflicts with the ExFAT mount
        ExecStart = ''
          ${execStartCmd} ${concatStringsSep " " argsList}
        '';
        Restart = "on-failure";
        RestartSec = "5s";
        Environment = [
          "PORT=8080"
          "LOCALAI_ADDR=127.0.0.1"
        ];
      };
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        # We still mkdir, but the ownership is mostly managed by the ExFAT mount options (uid=9300, gid=9400).
        mkdir -p ${cfg.modelDir}
      '';
    };
  };
}
