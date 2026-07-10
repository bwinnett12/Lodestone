# TODO - Improve this 
{
  inputs,
  self,
  ...
}: {
	imports = [
		./modules
		./citizens
		#./hardware
		./lib
	];
}