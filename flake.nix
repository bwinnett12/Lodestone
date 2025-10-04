{
  description = "a NixOS Flake for Me";

  #### Inputs
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    ### Cosmic flake
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.url = "github:NixOS/nixpkgs/9807714d6944a957c2e036f84b0ff8caf9930bc0";
    };
  };

  #### Outputs
  outputs = { self, nixpkgs, nixos-cosmic, ... }: {


    ####### Machines available

    # ~~!~~~~~~!~~~~~~!~~~~~~!~~~~~~!~~~~~~!~~~~~!~~!~~~~~~!~~~~~~! #

    ### Loom
    ## Originally a A Microsoft Surface Book 2 
    nixosConfigurations.Loom = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; 

      modules = [
        ./hosts/loom/configuration.nix
        ./hosts/loom/hardware-configuration.nix
      ];

      ### Additional Arguments 
      specialArgs = {
        inherit self; 
        nixosCosmicModule = nixos-cosmic.nixosModules.default;
      };
    };

    # ~~!~~~~~~!~~~~~~!~~~~~~!~~~~~~!~~~~~~!~~~~~!~~!~~~~~~!~~~~~~! #


    ### Island
    ## A basic desktop PC
    nixosConfigurations.Island = nixpkgs.lib.nixosSystem {
    
      ## System Architecture
      system = "x86_64-linux";

      ## Import modules
      modules = [

        ## Machine Specific Configuration
        ./hosts/island/configuration.nix
        ./hosts/island/hardware-configuration.nix
        #./home.nix

        ### The Big Frog
        ## Story:
        ## There is none
        ./modules/The-Big-Frog/main.nix
        
        ## Additional Modules
        ./modules/localai/main.nix

      ];


      ### Additional Arguments
      specialArgs = {
        inherit self;
        nixosCosmicModule = nixos-cosmic.nixosModules.default;
      };
    };


    # ~~!~~~~~~!~~~~~~!~~!~~~~~~!~~~~~~!~~~~~~!~~!~~x~x~~!~~!~~~~~! # 

  };
}
