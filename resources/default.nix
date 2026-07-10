# TODO - Improve this 
{
  inputs,
  self,
  ...
}: {
	imports = [
		./modules
		./citizens
		./citizens/exports.nix
		#./hardware
		
	];
}