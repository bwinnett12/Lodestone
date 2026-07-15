# resources/modules/hosts/default.nix
{ inputs, self, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.zotero
  ];

}
