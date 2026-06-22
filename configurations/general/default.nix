# configurations/general/default.nix
{ ... }: {
  imports = [
    ./games.nix
    ./communications.nix
    ./development
  ];
}