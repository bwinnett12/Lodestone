inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/master";
  home-manager = {
    url = "github:nix-community/home-manager/master";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  nixos-hardware.url = "github:NixOS/nixos-hardware/master";
};

outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }: {
  nixosConfigurations = {
    Loom = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/configuration.nix # Point to the correct path
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.tarobutter = import ./home.nix;
        }
        nixos-hardware.nixosModules.microsoft-surface-book2
      ];
    };
  };
};
