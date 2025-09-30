{ config, pkgs, ... }:

let
  pyEnv = pkgs.python310.withPackages (ps: with ps; [
    transformers
    torch
    sentencepiece
    requests
  ]);
in
{
  imports = [
   # /etc/nixos/modules/gpt-neo-llm.nix
  ];

  environment.systemPackages = [ pyEnv ];

  services.gpt-neo-llm.enable = true;
  services.gpt-neo-llm.python = pyEnv;
  services.gpt-neo-llm.hfModelId = "EleutherAI/gpt-neo-125M";
  services.gpt-neo-llm.autoDownload = true;
  services.gpt-neo-llm.modelPath = "/var/lib/gpt-neo/model";
  services.gpt-neo-llm.listenAddr = "127.0.0.1";
  services.gpt-neo-llm.listenPort = 8080;
  services.gpt-neo-llm.extras = []; # handled by pyEnv

  services.tutor-lang.enable = true;
  services.tutor-lang.modelServerUrl = "http://127.0.0.1:8080";
  services.tutor-lang.listenAddr = "127.0.0.1";
  services.tutor-lang.listenPort = 8081;
  services.tutor-lang.requestTimeoutSec = 60;
}

