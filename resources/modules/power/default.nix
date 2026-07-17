# resources/modules/power/default.nix
{ ... }: {
  imports = [
    ./options.nix
    ./portable.nix
    ./dependent.nix
    # ./tablet.nix
  ];
}