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
        };
      };
  in {
    Island = mkSystem "Island" "x86_64-linux";
    Loom = mkSystem "Loom" "x86_64-linux";
    Locomotive = mkSystem "Locomotive" "aarch64-linux";
  };
}