## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
## Lodestone devShells
## Enter with: nix develop .#<shell-name>
## Default (bare `nix develop`) enters the lodestone shell
{ ... }: {
  imports = [
    ./lodestone.nix
    ./video.nix
  ];

  perSystem = { config, ... }: {
    devShells.default = config.devShells.lodestone;
  };
}
