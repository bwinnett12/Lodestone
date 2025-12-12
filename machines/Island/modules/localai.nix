{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.localai;
  localaiBasePath = builtins.substring 0 (builtins.stringLength cfg.modelDir - builtins.stringLength "/models") cfg.modelDir;

  ## Define binary to retrieve
  binaryUrl = "https://github.com/mudler/LocalAI/releases/download/${cfg.version}/local-ai-${cfg.version}-linux-amd64";  

  ## Retrieve tarballsha from config
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

  ## Retrieve binary from nix store
  localai-bin = pkgs.runCommand "localai-binary-${cfg.version}" { } ''
    mkdir -p $out/bin
    install -m755 ${binarySrc} $out/bin/localai
  '';

  localaiStorePath = "${localai-bin}/bin/localai";
  execStartCmd = if cfg.binaryPath != null then cfg.binaryPath else localaiStorePath;
  argsList = ["run"] ++ cfg.extraArgs;

  llama-cpp-wrapper = pkgs.writeScriptBin "llama-cpp-grpc" ''
    #!${pkgs.stdenv.shell}
    exec ${pkgs.llama-cpp}/bin/llama-server "$@"
  '';

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
      default = "sha256:d9c5a8697f365922cf61c69e20f4504aefd4fedcdda8ac6876ae5892f6015e63";
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

      path = [ pkgs.llama-cpp llama-cpp-wrapper ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        WorkingDirectory = localaiBasePath;
        ExecStartPre = ""; # Kept empty to prevent chown conflicts with the ExFAT mount

        
        ExecStart = ''
          ${execStartCmd} ${concatStringsSep " " argsList}
        '';
        PermissionsStartOnly = true;
        Restart = "on-failure";
        RestartSec = "5s";
        Environment = [ 
          "PORT=${toString cfg.listenPort}"
          "LOCALAI_ADDR=${cfg.listenAddr}"
          "PATH=${llama-cpp-wrapper}/bin:$PATH" 
        ];
      };
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        ${pkgs.coreutils}/bin/mkdir -p /storage/Orchid/shortstack/localai/backends
        ${pkgs.coreutils}/bin/mkdir -p /storage/Orchid/shortstack/localai/configuration
        ${pkgs.coreutils}/bin/chown -R localai:localai /storage/Orchid/shortstack/localai
      '';
    };
  };
}