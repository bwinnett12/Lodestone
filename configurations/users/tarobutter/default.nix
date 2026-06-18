# configurations/users/tarobutter/default.nix
{ ... }: {
  imports = [
    ../../general/games.nix
    ../../general/communications.nix
  ];

  profiles.gaming = {
    enable = true;
    pokemmo = true;
    runescape = true;
  };

  profiles.communications = {
    enable = true;
    professional = true;
    gaming = true;
  };
}