# resources/modules/roles/builder.nix
{ lib, ... }:
{
  nix.settings.extra-platforms = [ "aarch64-linux" "armv7l-linux" ];
  boot.binfmt.emulatedSystems  = [ "aarch64-linux" "armv7l-linux" ];
  nix.settings.max-jobs = lib.mkDefault 4;
  nix.settings.cores    = lib.mkDefault 0;
}