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

  outputs = { self, nixpkgs, nixos-hardware, cosmic, ... }@inputs: 
   

   let 
      # Define the system architecture
      # We take the system from the nixpkgs input for consistency
      system = "x86_64-linux";

      # Define pkgs for the current system using the system variable
      pkgs = import nixpkgs {
         inherit system;
         config = {
           allowUnfree = true;
         };
      };  

      # Explicitly get mkShell from the pkgs set
      mkShell = pkgs.mkShell;

   in
   {
    nixosConfigurations.Loom = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # Set your system architecture (e.g., "aarch64-linux" for ARM)

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

        ## Base Docker
        ./modules/docker.nix
        

        ## Sonarr
        #./modules/docker_images/sonarr.nix

      ];

      specialArgs = { inherit self cosmic; };
    };
    


    # devshells for video editing tools 
    devShells.${system}.video-tools = mkShell { # Correctly use the 'mkShell' defined in the let block
      packages = with pkgs; [ # Correctly use 'pkgs' defined in the let block
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
