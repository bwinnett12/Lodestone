{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations = let
    mkSystem = name: system:
      inputs.nixpkgs.lib.nixosSystem {
        modules = [
          ./${name}
        ];
        specialArgs = {
          inherit inputs self;
        };
      };
  in {
    Island = mkSystem "Island" "x86_64-linux";

    Loom = mkSystem "Loom" "x86_64-linux";

    locomotive = mkSystem "locomotive" "aarch64-linux";

    
  };
}
