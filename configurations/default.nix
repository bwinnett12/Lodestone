# configurations/default.nix
{ ... }: {
  imports = [
    ./general
    ./citizens
    ./shortstack
  ];
}