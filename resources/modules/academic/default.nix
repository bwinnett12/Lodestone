# resources/modules/hosts/default.nix
{ inputs, self, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.zotero
    pkgs.libreoffice
    pkgs.hunspell
    pkgs.hunspellDicts.en_US
    pkgs.hunspellDicts.th_TH
    # pkgs.hunspellDiscts.jp_JP
  ];
}
