# configurations/citizens/users/tarobutter/system.nix
{ ... }: {
  ecosystem.users.tarobutter = {
    description = "Tarot D. Butter";
    extraGroups = [ "networkmanager" "systemd-journal" "wheel" "docker" "input" "video" "render" "storage" ];
    homeManagerModule = ./home.nix;
    upgraded = true;
    uid = 1500;
  };
}