{ lib, pkgs, config, options, ... }:

with lib;

let
  cfg = config.services.localai;
in
{
  options.services.localai = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable LocalAI Docker container service.";
    };

    image = mkOption {
      type = types.str;
      default = "quay.io/go-skynet/local-ai:latest";
      description = "Container image to run for LocalAI.";
    };

    listenPort = mkOption {
      type = types.int;
      default = 8080;
      description = "Host port to expose LocalAI HTTP API on.";
    };

    modelsPath = mkOption {
      type = types.str;
      default = "/var/lib/localai/models";
      description = "Directory on the host to store model files.";
    };

    containerName = mkOption {
      type = types.str;
      default = "localai";
      description = "Name for the Docker container.";
    };

    extraEnv = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "Extra environment variables to pass to the container.";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Extra arguments appended to the docker run command.";
    };
  };

  config = mkIf cfg.enable {
    # Ensure Docker is enabled
    virtualisation.docker.enable = true;

    # Create models directory at activation time with proper perms
    system.activationScripts.localai-mkdir = {
      text = ''
        mkdir -p ${cfg.modelsPath}
        chown root:root ${cfg.modelsPath}
        chmod 0755 ${cfg.modelsPath}
      '';
      deps = [ "local-fs.target" ];
    };

    systemd.services.localai-docker = {
      description = "LocalAI (Docker container)";
      wants = [ "network-online.target" "docker.service" ];
      after = [ "network-online.target" "docker.service" ];
      serviceConfig = {
        Restart = "always";
        RestartSec = "5s";
        KillMode = "control-group";
      };
      script = ''
        # ensure models dir exists
        mkdir -p ${cfg.modelsPath}

        # remove any previous container with same name
        if docker ps -a --format '{{.Names}}' | grep -qx "${cfg.containerName}"; then
          docker rm -f ${cfg.containerName} || true
        fi

        # build environment options
        env_args=()
        ${lib.concatMapStrings (k: ''
          env_args+=( -e ${k}="${cfg.extraEnv.${k}}" )
        '') (attrNames cfg.extraEnv)}

        # prepare volume mapping
        volume_arg="-v ${cfg.modelsPath}:/models"

        # port mapping
        port_arg="-p ${toString cfg.listenPort}:8080"

        # container image and extra args
        image="${cfg.image}"
        extra='${lib.concatStringsSep " " cfg.extraArgs}'

        docker run --name ${cfg.containerName} -d ${port_arg} ${volume_arg} ${lib.concatStringsSep " " (map (s: s) (builtins.splitString " " (builtins.trace "" "${lib.concatStringsSep " " cfg.extraArgs}"))) } ${lib.concatStringsSep " " (map (k: "-e " + k + "=\"" + cfg.extraEnv.${k} + "\"") (attrNames cfg.extraEnv))} ${image} ${extra} --models-path /models
      '';
      wantedBy = [ "multi-user.target" ];
    };
  };
}

