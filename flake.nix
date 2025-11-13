## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
## Flakes are fun
## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##

{
  description = "a NixOS Flake for Me";

  #### Inputs
  inputs = {

    ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
    #### Package repository sources
    ## Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    

    ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
    ## Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";


    ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
    ### Desktop sources
    ## Cosmic flake
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.url = "github:NixOS/nixpkgs/9807714d6944a957c2e036f84b0ff8caf9930bc0";
    };

    ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  };



  #### Outputs
  outputs = { self, nixpkgs, nixos-cosmic, home-manager, ... }: {


    ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ #
    ####### Machines available
    # ~~!~~~~~~!~~~~~~!~~~~~~!~~~~~~!~~~~~~!~~~~~!~~!~~~~~~!~~~~~~! #

    ### Loom
    ## Originally a A Microsoft Surface Book 2 
    nixosConfigurations.Loom = nixpkgs.lib.nixosSystem {

      ## System Architecture
      system = "x86_64-linux";


      ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
      modules = [
        ./machines/loom/configuration.nix
      ];


      ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
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


      ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
      ## Import modules
      modules = [

        ## Machine Specific Configuration
        ./machines/island/configuration.nix

        let
         hm = home-manager.lib;
        in
        {
          home-manager.nixosModules.home-manager
          (hm.homeManagerConfiguration {
          pkgs = pkgs;
          modules = [ ./home ];
          # optional:
          # username = "tarobutter";
          # homeDirectory = "/home/tarobutter";
          })
        }



        ### Shortstack
        ./modules/shortstack/main.nix
        
        

        ### Storage options
        ./modules/hardware/storage/nettle.nix
        ./modules/hardware/storage/orchid.nix
        ./modules/hardware/storage/yarrow.nix


      ];


      ### Additional Arguments
      specialArgs = {
        inherit self;
        nixosCosmicModule = nixos-cosmic.nixosModules.default;
      };
    };

    # ~~!~~~~~~!~~~~~~!~~~~~~!~~~~~~!~~~~~~!~~~~~!~~!~~~~~~!~~~~~~! #






    ### Locomotive
    ## A raspberry pi 4
    nixosConfigurations.Locomotive = nixpkgs.lib.nixosSystem {
    
      ## System Architecture
      system = "x86_64-linux";  ## Fix this


      ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
      ## Import modules
      modules = [

        ## Machine Specific Configuration
        ./hosts/locomotive/configuration.nix


        let
         hm = home-manager.lib;
        in
        {
          home-manager.nixosModules.home-manager
          (hm.homeManagerConfiguration {
          pkgs = pkgs;
          modules = [ ./home ];
          # optional:
          # username = "tarobutter";
          # homeDirectory = "/home/tarobutter";
          })
        }

      ];
    };

   # ~~!~~~~~~!~~~~~~!~~~~~~!~~~~~~!~~~~~~!~~~~~!~~!~~~~~~!~~~~~~! #


    devShells."x86_64-linux".video-tools = nixpkgs.legacyPackages."x86_64-linux".mkShell {
      packages = with nixpkgs.legacyPackages."x86_64-linux".pkgs; [ handbrake makemkv mkvtoolnix flac cdparanoia abcde ];
      shellHook = ''echo "Entering video transcoding shell." '';
      };


    # ~~!~~~~~~!~~~~~~!~~!~~~~~~!~~~~~~!~~~~~~!~~!~~x~x~~!~~!~~~~~! # 

  };
}
