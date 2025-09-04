self: super:
{
  quetzalcoatl = (super.stdenv.mkDerivation {
    name = "quetzalcoatl";
    src = super.fetchurl {
      url = "https://github.com/publicsamples/Quetzalcoatl/releases/download/0.6.5.1/Quetzalcoatl.vst3.tar.xz";
      sha256 = "sha256-T1gc+B6CvsfxRlb2KNoU0DVGyIcV1NlDpJoRoGva41w=";
    };
    nativeBuildInputs = with super; [
      autoPatchelfHook
    ];

    buildInputs = with super; [
      alsa-lib
      freetype
      libGL
      (lib.getLib stdenv.cc.cc)
    ];

    installPhase = ''
      tar -xf $src
      mkdir -p $out/lib/vst3
      cp -r *.vst3 $out/lib/vst3
    '';
  });
}

