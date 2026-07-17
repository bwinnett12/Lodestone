# resources/modules/power/default.nix
{ ... }: {
  imports = [
    ./options.nix
    ./portable.nix
    ./stationary.nix
    # ./tablet.nix
  ];
}