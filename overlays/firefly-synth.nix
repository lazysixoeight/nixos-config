self: super:
{
  firefly-synth = (super.stdenv.mkDerivation {
    name = "firefly-synth";
    src = super.fetchurl {
      url = "https://github.com/sjoerdvankreel/firefly-synth/releases/download/v1.9.9/firefly_synth_1.9.9_linux_vst3_instrument.zip";
      sha256 = "sha256-bkMVbXFfpdeCst0ynrpIofkD4l6OP+LrajV52vasalA=";
    };
    nativeBuildInputs = with super; [
      autoPatchelfHook
      unzip
    ];

    buildInputs = with super; [
      alsa-lib
      freetype
      fontconfig
      (lib.getLib stdenv.cc.cc)
    ];

    installPhase = ''
      unzip $src
      mkdir -p $out/lib/vst3
      cp -r *.vst3 $out/lib/vst3
    '';
  });
}

