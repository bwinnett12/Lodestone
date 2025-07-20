{
  description = "A minimal NixOS flake";

  inputs = {
    # Nixpkgs provides all the packages and modules for NixOS.
    # We'll use the 'nixos-unstable' branch for the latest features,
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    ## For specific hardware: Surface
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    ## Cosmic Flake source
    cosmic.url = "github:lilyinstarlight/nixos-cosmic";    
  };

  outputs = { self, nixpkgs, nixos-hardware, cosmic, ... }: {
    # Define a NixOS configuration for a host named 'my-nixos-machine'.
    # You should change 'my-nixos-machine' to your desired hostname.
    nixosConfigurations.Loom = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # Set your system architecture (e.g., "aarch64-linux" for ARM)

      # 'modules' is a list of Nix expressions that define your system.
      # Right now, it's empty, so this system will be extremely barebones.
      modules = [
        ## Base configuration
        ./hosts/loom/configuration.nix

        ## Hardware Configuration
        ./hosts/loom/hardware-configuration.nix

        ## Surface-book 2 module
        # Falls under common
        "${nixos-hardware}/microsoft/surface/common"
        
	## Cosmic Desktop environment
        cosmic.nixosModules.default
      ];

      # You can pass additional arguments to your modules here if needed.
      specialArgs = { inherit self cosmic; };
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
