{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.logseq
  ];
}
