
# Simply importing plan 9
# resources/modules/plan9/default.nix
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

