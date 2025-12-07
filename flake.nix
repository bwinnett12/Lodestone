## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
## Flakes are fun
## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##

{
  description = "a NixOS Flake for Me";

  ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  #### Inputs
  inputs = {

    #### Package repo sources
    ## Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    ## Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Flake Utils
    flake-utils = {
      url = "github:numtide/flake-utils";
    };


    flake-parts.url = "github:hercules-ci/flake-parts";



    ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
    ### Desktop sources
    ## Cosmic flake
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.url = "github:NixOS/nixpkgs/9807714d6944a957c2e036f84b0ff8caf9930bc0";
    };

    ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
  };


outputs = {
    self,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];
      imports = [
        ./machines

      ];
    };


    # ~~!~~~~~~!~~~~~~!~~~~~~!~~~~~~!~~~~~~!~~~~~!~~!~~~~~~!~~~~~~! #
    #### Dev Shells
#    devShells."x86_64-linux".video-tools = pkgs.legacyPackages."x86_64-linux".mkShell {
#      packages = with pkgs.legacyPackages."x86_64-linux".pkgs; [ handbrake makemkv mkvtoolnix flac cdparanoia abcde ];
#      shellHook = ''echo "Entering video transcoding shell." '';
#    };
}
