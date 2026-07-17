# resources/modules/power/exports.nix
{ self, ... }: {
  flake.ecosystem.power = self.nixosModules.power;
}