self: super:
{
  membrane-synth = (super.stdenv.mkDerivation {
    name = "membrane-synth";
    src = super.fetchurl {
      url = "https://github.com/ryukau/VSTPlugins/releases/download/UhhyouPlugins0.66.0/MembraneSynth_0.1.10.zip";
      sha256 = "sha256-nTmHZVnX3CGDJAY4HP2j2g5v2cdQRD6crRlaeS3aShg=";
    };
    nativeBuildInputs = with super; [
      autoPatchelfHook
      unzip
    ];

    unpackPhase = ''
      unzip "$src" -x /
    '';

    buildInputs = with super; [
      (stdenv.cc.cc)
      (stdenv.cc.cc.lib)
      libxcb
      libxcb-cursor
      glib
      fontconfig
      cairo
      libxkbcommon
      pango
    ];

    installPhase = ''
      mkdir -p $out/lib/vst3
      cp -r *.vst3 $out/lib/vst3
    '';
  });
}

