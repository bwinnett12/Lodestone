## machines/default.nix
{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations = let
    mkSystem = name: system:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          self.ecosystem.common
          ./${name}
        ];
        specialArgs = {
          inherit inputs self;
          lodestoneRoot = self;
        };
      };
  in {
    Island = mkSystem "Island" "x86_64-linux";
    Loom = mkSystem "Loom" "x86_64-linux";
    Locomotive = mkSystem "Locomotive" "aarch64-linux";
  };

  flake.darwinConfigurations = let
    mkDarwinSystem = name: system:
      inputs.nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          # self.ecosystem.common   # only include if it's OS-agnostic; NixOS-specific options will fail on darwin
          ./${name}
        ];
        specialArgs = {
          inherit inputs self;
          lodestoneRoot = self;
        };
      };
  in {
    W-Mac = mkDarwinSystem "W-Mac" "aarch64-darwin";
  };
}