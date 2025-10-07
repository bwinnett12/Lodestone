### Academic Modules
### Zotero
### ./modules/academic/zotero/main.nix

{ config, pkgs, ...}: 

{
environment.systemPackages = [
    pkgs.zotero
  ];
}