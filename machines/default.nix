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
    island = mkSystem "island";
    # locomotive = mkSystem "locomotive";
    loom = mkSystem "loom";
  };
}
