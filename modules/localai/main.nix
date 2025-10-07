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

  localai-bin = pkgs.buildGoModule rec {  
    pname = "localai";
    version = cfg.version;
    src = pkgs.fetchFromGitHub {
      owner = "mudler";
      repo = "LocalAI";
      rev = cfg.version;
      sha256 = "sha256:f92f5360e8839c988e54f46cf4e35d5ea7dd700c49d7330e048245f1eff42a18; 
    };

    buildInputs = [
      pkgs.llama-cpp # Dependency for GGUF support
    ];

    buildFlagsArray = [ "-tags" "llama-cpp,gpt4all" ]; 
    vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; 
  };

  localaiStorePath = "${localai-bin}/bin/localai";
  execStartCmd = if cfg.binaryPath != null then cfg.binaryPath else localaiStorePath;
  argsList = ["run"] ++ cfg.extraArgs;


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

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        WorkingDirectory = localaiBasePath; 
        ExecStartPre = "";
        ExecStart = ''
          ${execStartCmd} ${concatStringsSep " " argsList}
        '';
        Restart = "on-failure";
        RestartSec = "5s";
        Environment = [
          # Port configuration for LocalAI is usually set via this variable:
          "PORT=8080"
          
          # Address configuration is often LOCALAI_ADDR or just ADDR.
          # We'll use the most common one, or you can try LOCALAI_ADDR=127.0.0.1 if PORT fails.
          "LOCALAI_ADDR=127.0.0.1"
        ];
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