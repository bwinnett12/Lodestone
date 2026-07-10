# resources/citizens/default.nix
{ ... }: {
  flake.ecosystem.citizens = {
    humans = import ./humans.nix;
    functionaries = import ./functionaries.nix;
  };
}