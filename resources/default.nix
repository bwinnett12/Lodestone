# TODO - Improve this 
{
  inputs,
  self,
  ...
}: {
	imports = [
		./modules
		./modules/common/exports.nix
		./citizens
		./environments
		#./hardware
		./lib
	];
}