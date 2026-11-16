{ self, ... }:
{
  imports = [ self.nixosModules.editor ];

  ecosystem.editor.languages = [ "rust" "python" "r" "julia" ];

  ecosystem.environments.neovim.enable = true;
}
