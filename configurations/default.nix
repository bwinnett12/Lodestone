
# Simply importing the general configurations
{
  inputs,
  self,
  ...
}: {

	imports = [
    ./general
    ./home
	#./shortstack
	  ./users
	];
}