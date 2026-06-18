
# Simply importing plan 9
{
  inputs,
  self,
  ...
}: {

	imports = [
    ./u9fs-client.nix
    ./u9fs-server.nix
	];
}

