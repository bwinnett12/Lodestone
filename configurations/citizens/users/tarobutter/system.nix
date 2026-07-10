# configurations/users/tarobutter/system.nix
{ ... }: {
  ecosystem.users.tarobutter = {
    description = "Tarot D. Butter";
    extraGroups = [ "networkmanager" "systemd-journal" "wheel" "docker" "input" "video" "render" ];
    homeManagerModule = ./home.nix;
  };
}