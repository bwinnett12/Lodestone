{
  description = "A minimal NixOS flake";

  inputs = {
    # Nixpkgs provides all the packages and modules for NixOS.
    # We'll use the 'nixos-unstable' branch for the latest features,
    # but you could change this to a specific stable release like "nixos-24.05".
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
     # Add the nixos-cosmic flake here
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs"; # Crucial for consistency
    };
  };

  outputs = { self, nixpkgs, nixos-cosmic, ... }: {
    # Define a NixOS configuration for a host named 'my-nixos-machine'.
    # You should change 'my-nixos-machine' to your desired hostname.
    nixosConfigurations.Loom = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # Set your system architecture (e.g., "aarch64-linux" for ARM)

      # 'modules' is a list of Nix expressions that define your system.
      # Right now, it's empty, so this system will be extremely barebones.
      modules = [
        ./hosts/loom/configuration.nix
        ./hosts/loom/hardware-configuration.nix
      ];

      # You can pass additional arguments to your modules here if needed.
      specialArgs = { };
    };
  };
}
