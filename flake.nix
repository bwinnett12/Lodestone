{
  description = "A minimal NixOS flake";

  inputs = {
    # Nixpkgs provides all the packages and modules for NixOS.
    # We'll use the 'nixos-unstable' branch for the latest features,
    # but you could change this to a specific stable release like "nixos-24.05".
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }: {
    # Define a NixOS configuration for a host named 'my-nixos-machine'.
    # You should change 'my-nixos-machine' to your desired hostname.
    nixosConfigurations.Loom = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # Set your system architecture (e.g., "aarch64-linux" for ARM)

      # 'modules' is a list of Nix expressions that define your system.
      # Right now, it's empty, so this system will be extremely barebones.
      modules = [
        ./hosts/loom/configuration.nix
        ./hosts/loom/hardware-configuration.nix
        "${nixos-hardware}/microsoft/surface/common"
      ];

      # You can pass additional arguments to your modules here if needed.
      specialArgs = { };
    };

    devShells.x86_64-linux.video-tools = nixpkgs.mkShell {
      packages = with nixpkgs; [
        handbrake
        makemkv
        mkvtoolnix
      ];
      shellHook = ''
        echo "Entering video transcoding shell from flake."
        echo "HandBrake, MakeMKV, and MKVToolNix are available."
      '';
    };
  };
}
