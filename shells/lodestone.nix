## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
## Lodestone infrastructure shell
## Enter with: nix develop .#lodestone
{ ... }:
{
  perSystem = { pkgs, ... }: {
    devShells.lodestone = pkgs.mkShell {
      name = "lodestone";

      packages = with pkgs; [
        git
        openssh
        nix
      ];

      shellHook = ''
        ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
        export LODESTONE_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo $PWD)"
        export PATH="$LODESTONE_ROOT/scripts/rebuild:$PATH"

        ## Auto-generate shell-* functions for every devShell in the flake
        while IFS= read -r shell; do
          eval "shell-$shell() { nix develop $LODESTONE_ROOT#$shell \"\$@\"; }"
        done < <(nix flake show "$LODESTONE_ROOT" 2>/dev/null \
          | grep "devShell" \
          | grep -oP "(?<=─ )\w+" \
          | grep -v "^$")

        echo ""
        echo "🏝  Lodestone — infrastructure shell"
        echo ""
        echo "  Commands:"
        echo "    refresh                        rebuild this machine"
        echo "    refresh <host>                 rebuild target host"
        echo "    refresh <host> --by <builder>  build on <builder>, deploy to <host>"
        echo "    refresh <host> --self          target rebuilds itself"
        echo "    refresh <host> --dry           dry run, no apply"
        echo "    shells                         list available shells"
        echo ""
        echo "  Available shells:"
        nix flake show "$LODESTONE_ROOT" 2>/dev/null \
          | grep "devShell" \
          | grep -oP "(?<=─ )\w+" \
          | grep -v "^$" \
          | while read -r s; do
              echo "    shell-$s"
            done
        echo ""
      '';
    };
  };
}
