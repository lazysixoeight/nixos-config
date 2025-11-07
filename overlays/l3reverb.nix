self: super:
{
  l3reverb = (super.stdenv.mkDerivation {
    name = "membrane-synth";
    src = super.fetchurl {
      url = "https://github.com/ryukau/VSTPlugins/releases/download/UhhyouPlugins0.66.0/L3Reverb_0.1.22.zip";
      sha256 = "sha256-HO95/v1Qwy+GGyb16lR/mqaTWQqpoOEZxvvsW3xeKaE=";
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

