{ self, config, lib, pkgs, ... }: {
  imports = [
    self.nixosModules.steam
    self.nixosModules.discord
    self.nixosModules.pokemmo
    self.nixosModules.firefox
  ];

  # Pre-configure each module with shortstack's opinions
  modules.steam.enable   = true;
  modules.discord.enable = true;
  modules.pokemmo.enable = true;

  #modules.firefox = {
  #  enable   = true;
  #  profile  = "gaming";    # maybe sets different homepage, extensions, etc.
  #};
}