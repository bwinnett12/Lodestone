## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
## Video transcoding shell
## Enter with: nix develop .#video
{ ... }:
{
  perSystem = { pkgs, ... }: {
    devShells.video = pkgs.mkShell {
      name = "video-tools";

      packages = with pkgs; [
        handbrake
        makemkv
        mkvtoolnix
        flac
        cdparanoia
        abcde
        ffmpeg
      ];

      shellHook = ''
        ## ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ -!!- ~~~~~ ##
        echo ""
        echo "🎬  Video tools shell"
        echo ""
        echo "  handbrake     GUI/CLI video transcoder"
        echo "  makemkv       Blu-ray / DVD ripping"
        echo "  mkvtoolnix    MKV inspection and editing"
        echo "  ffmpeg        General transcoding"
        echo "  flac          Lossless audio encoding"
        echo "  cdparanoia    CD audio ripping"
        echo "  abcde         CD ripping pipeline"
        echo ""
      '';
    };
  };
}