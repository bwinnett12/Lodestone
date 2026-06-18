
# Simply importing the general configurations
{
  inputs,
  self,
  ...
}: {

	imports = [
    ./games.nix
    ./communications.nix
	];
}

