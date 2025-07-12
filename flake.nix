{
  description = "Treehouse: Loom - Surface Book 2 on NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05"; # IMPORTANT: Match your NixOS version
    # Home Manager; home manager; home-manager; HomeManager 
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05"; # IMPORTANT: Match your NixOS version
      inputs.nixpkgs.follows = "nixpkgs"; 
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.Loom = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";  
      modules = [
        ./nixos/configuration.nix # Base configuration
        
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.yourUsername = import ./home.nix; # Create this file soon
        }
      ];
      specialArgs = { inherit inputs; }; # Pass inputs to modules if needed
    };
  };
}
