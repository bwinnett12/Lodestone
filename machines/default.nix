{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations = let
    mkSystem = name:
      inputs.nixpkgs.lib.nixosSystem {
        modules = [
          ./${name}
        ];
        specialArgs = {
          inherit inputs self;
        };
        system = "x86_64-linux";
      };
  in {
    Island = mkSystem "Island";
    # locomotive = mkSystem "locomotive";
    Loom = mkSystem "Loom";
  };
}
