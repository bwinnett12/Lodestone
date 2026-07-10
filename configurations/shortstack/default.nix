# configurations/shortstack/default.nix
{ config, lib, ... }: {
  options.profiles.shortstack.enable = lib.mkEnableOption "Shortstack mailroom stack";
  config = lib.mkIf config.profiles.shortstack.enable {
    # ecosystem.functionaries.pamona.enable = true;
    # services.mailroom.enable = true;
  };
}