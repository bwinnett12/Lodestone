# resources/modules/power/default.nix
{ ... }: {
  imports = [
    ./options.nix
    ./portable.nix
    ./stationary.nix
    ./cosmic-ppd-shim.nix
    # ./tablet.nix
  ];
}